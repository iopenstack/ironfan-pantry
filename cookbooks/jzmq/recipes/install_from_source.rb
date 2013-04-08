include_recipe 'github'

package 'pkg-config'
package 'libtool'

sources_dir = "#{Chef::Config[:file_cache_path]}/jzmq"

deploy "#{sources_dir}" do
    not_if          { ::File.exists?("#{sources_dir}/current/autogen.sh") }
    repo            node[:jzmq][:repo]
    revision        'master'
    symlinks.clear
    symlink_before_migrate.clear
    migrate         false
    user            'root'
    group           'root'
    action          :deploy
end

execute "bootstrap" do
    not_if      { ::File.exists?("/usr/local/lib/libjzmq.a") }
    user        'root'
    cwd         "#{sources_dir}/current"
    creates     "#{sources_dir}/current/Makefile"
    command     './autogen.sh && ./configure'
end

execute "make" do
    not_if      { ::File.exists?("/usr/local/lib/libjzmq.a") }
    user        'root'
    cwd         "#{sources_dir}/current"
    command     'make'
    returns     [0,2]
end

execute "patch" do
    user        'root'
    cwd         "#{sources_dir}/current/src"
    command     'touch classdist_noinst.stamp && CLASSPATH=.:./.:$CLASSPATH javac -d . org/zeromq/ZMQ.java org/zeromq/App.java org/zeromq/ZMQForwarder.java org/zeromq/EmbeddedLibraryTools.java org/zeromq/ZMQQueue.java org/zeromq/ZMQStreamer.java org/zeromq/ZMQException.java'
    creates     "#{sources_dir}/current/src/zmq.jar"
end

execute "install" do
    not_if      { ::File.exists?("/usr/local/lib/libjzmq.a") }
    user        'root'
    cwd         "#{sources_dir}/current"
    creates     '/usr/local/lib/libjzmq.a'
    command     'make install'
end

