class Ignite3Cli < Formula
  desc "Apache Ignite 3 Command Line Tool"
  homepage "https://ignite.apache.org"
  url "https://dlcdn.apache.org/ignite/3.0.0-beta1/ignite3-cli-3.0.0-beta1.zip"
  sha256 "526d492d93b483cb4cc5b2b1d00190866f1883fcfe9e5104244dc3d5c0e26a87"

  license ""

  depends_on "openjdk@11"

  def install
    rm_f Dir["bin/*.bat"]
   
    libexec.install "lib"
    libexec.install "bin"
    bin.install_symlink libexec/"bin/ignite3"
    bash_completion.install libexec/"bin/ignite_completion.sh" => "ignite3"
  end

  def caveats
    <<~EOS
      Add the following line to your ~/.bash_profile or ~/.zshrc:
       source /usr/local/etc/bash_completion.d/ignite3
    EOS
  end

  test do
    system "#{bin}/ignite3", "--help"
  end
end
