{ stdenv, fetchurl, apacheHttpd, python2 }:

stdenv.mkDerivation rec {
  name = "mod_python-3.5.0";

  src = fetchurl {
    url = "http://dist.modpython.org/dist/${name}.tgz";
    sha256 = "146apll3yfqk05s8fkf4acmxzqncl08bgn4rv0c1rd4qxmc91w0f";
  };

  patches = [ ./install.patch ];

  postPatch = ''
    substituteInPlace dist/version.sh \
        --replace 'GIT=`git describe --always`' "" \
        --replace '-$GIT' ""
  '';

  installFlags = [ "LIBEXECDIR=${placeholder "out"}/modules" ];

  preInstall = ''
    mkdir -p $out/modules $out/bin
  '';

  passthru = { inherit apacheHttpd; };

  buildInputs = [ apacheHttpd python2 ];

  meta = {
    homepage = http://modpython.org/;
    description = "An Apache module that embeds the Python interpreter within the server";
    platforms = stdenv.lib.platforms.unix;
  };
}
