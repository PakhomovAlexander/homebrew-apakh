class Ignite3Db < Formula
  desc "Distributed Database For High‑Performance Applications With In‑Memory Speed"
  homepage "https://ignite.apache.org"
  url "https://dlcdn.apache.org/ignite/3.0.0-beta1/ignite3-db-3.0.0-beta1.zip"
  sha256 "0bead985b19b7dffd06924672d438d3b3a2ce5e4da1dac68b28b653f44ac2d20"
  license "Apache-2.0"


  def install
    #lib.install Dir["lib/*.jar"]
    libexec.install "lib"
    #bin.install "bin/ignite3db"
    libexec.install "bin"
    #(prefix/"etc/").install Dir["etc/*"]
    libexec.install "etc"
    (var/"log/#{name}").mkpath
    (var/"#{name}/work").mkpath
    
    inreplace "#{libexec}/bin/ignite3db" do |s|
      s.gsub! " exec ${CMD} >>${LOG_OUT_FILE:-/dev/null} 2>&1 < /dev/null & jobs -p > ${IGNITE_HOME}/pid", " exec ${CMD}"
    end
    
    inreplace "#{prefix/"libexec/etc"}/bootstrap-config.env" do |s|
      s.gsub! "WORK_PATH=$IGNITE_HOME/work", "WORK_PATH=#{var}/#{name}/work" 
    end
    
    inreplace "#{prefix/"libexec/etc"}/ignite.java.util.logging.properties" do |s|
      s.gsub! "java.util.logging.FileHandler.pattern = ./ignite3db-%g.log", "java.util.logging.FileHandler.pattern = #{var}/log/#{name}/#{name}-%g.log"
    end
  end

  test do
    system "true"
  end

  def ignite3_db_log_path
    var/"log/#{name}/#{name}-service.log"
  end

  service do
    #environment_variables IGNITE_HOME: opt_prefix
    run [libexec/"bin/ignite3db", "start"]
    keep_alive true
    log_path f.ignite3_db_log_path
    error_log_path f.ignite3_db_log_path
    working_dir opt_prefix
  end
end
