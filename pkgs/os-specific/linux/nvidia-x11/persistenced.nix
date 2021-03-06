nvidia_x11: sha256:

{ stdenv, fetchFromGitHub, m4 }:

stdenv.mkDerivation {
  pname = "nvidia-persistenced";
  inherit (nvidia_x11) version;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-persistenced";
    rev = nvidia_x11.version;
    inherit sha256;
  };

  nativeBuildInputs = [ m4 ];

  installFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    # Save a copy of persistenced for mounting in containers
    mkdir $out/origBin
    cp $out/{bin,origBin}/nvidia-persistenced
    patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 $out/origBin/nvidia-persistenced

    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/nvidia-persistenced):${nvidia_x11}/lib" \
      $out/bin/nvidia-persistenced
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.nvidia.com/object/unix.html";
    description = "Settings application for NVIDIA graphics cards";
    license = licenses.unfreeRedistributable;
    platforms = nvidia_x11.meta.platforms;
    maintainers = with maintainers; [ abbradar ];
  };
}
