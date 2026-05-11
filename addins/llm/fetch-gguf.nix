{ pkgs, lib }:

{ url, hash ? null, hashes ? null }:
let
  name = builtins.baseNameOf url;
  allHashes = if hashes != null then hashes else [ hash ];
  primaryHash = if hashes != null then builtins.head hashes else hash;
  drv = pkgs.fetchurl { inherit name url; hash = primaryHash; };

  remainingHashes = if hashes != null && builtins.length hashes > 1
    then builtins.tail hashes else [];

  mkShard = i: h:
    let
      match = builtins.match "(.+-)([0-9]+)(-of-[0-9]+)(\.[^.]+)$" name;
    in
    if match == null then throw "fetchGguf: cannot determine shard numbering for ${name}"
    else
      let
        prefix = builtins.elemAt match 0;
        numStr = builtins.elemAt match 1;
        rest = builtins.elemAt match 2;
        ext = builtins.elemAt match 3;
        width = builtins.stringLength numStr;
        shardNum = i + 1;
        padded = lib.fixedWidthNumber width shardNum;
        shardName = "${prefix}${padded}${rest}${ext}";
        shardUrl = builtins.replaceStrings [ "${numStr}${rest}" ] [ "${padded}${rest}" ] url;
      in { name = shardName; drv = pkgs.fetchurl { name = shardName; url = shardUrl; hash = h; }; };

  ofMatch = builtins.match ".*-of-0*([0-9]+)\.[^.]+$" name;
  expectedCount = if ofMatch == null then 1 else lib.toInt (builtins.head ofMatch);
  actualCount = builtins.length allHashes;
in
assert builtins.length allHashes == 1 || hashes != null;
assert lib.assertMsg (actualCount == expectedCount)
  "fetchGguf: ${name} expects ${toString expectedCount} hashes, got ${toString actualCount}";
{ inherit name drv; } // lib.optionalAttrs (remainingHashes != []) {
  shards = lib.imap1 (i: h: mkShard i h) remainingHashes;
}
