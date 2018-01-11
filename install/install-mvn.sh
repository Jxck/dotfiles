cd $DOTFILES/pkg
rm mvn
wget http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
tar -zxvf apache-maven-3.5.2-bin.tar.gz
mv apache-maven-3.5.2 mvn
rm apache-maven*
