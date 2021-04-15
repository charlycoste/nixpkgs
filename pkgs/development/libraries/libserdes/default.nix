{lib, stdenv, pkg-config, perl, jansson, curl, avro-c, rdkafka, boost, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libserdes";
  version = "6.1.1-cp1-rc2";

  src = fetchurl {
    url = "https://github.com/confluentinc/${pname}/archive/refs/tags/v${version}.tar.gz";
    sha256 = "128zmsq55kk99hd57nrikw5y8ybv7jz542hwcg9967dnnnspmhg1";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [
    jansson
    curl
    avro-c
    rdkafka
    boost
  ];

  meta = with lib; {
    description = "libserdes is a schema-based serializer/deserializer C/C++ library with support for Avro and the Confluent Platform Schema Registry.";
    homepage = "https://github.com/confluentinc/libserdes";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ charlycoste ];
  };
}
