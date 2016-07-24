#!/bin/bash
bintrayRepoName=""
bintrayUser=""

## Config bintray info
echo "## Bintray config" > ../bintray.properties
if [ $# == 2 ]
then
  echo "bintray.user = $1" >> ../bintray.properties
  echo "bintray.apikey = $2" >> ../bintray.properties
else
  echo "请输入你的bintray用户名, 例如：yat3s"
  read line
  echo "bintray.user = $line" >> ../bintray.properties
  bintrayUser=$line

  echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "请输入你的bintray apikey, 例如：8c1f37bdb49e4b64e8b1c4954e19bbf7a42045e3"
  read line
  echo "bintray.apikey = $line" >> ../bintray.properties
fi

## Config repo info
echo "## Deploy config" > ../deploy.settings
echo ">>>>>>>>>>>(1/4)>>>>>>>>>>>>>>>>>"
echo "接下来我们配置一下你的项目信息吧"
echo "告诉我你的项目的地址，例如：https://github.com/Yat3s/BaseRecyclerViewAdapter"
read line
echo "siteUrl = $line" >> ../deploy.settings
echo "gitUrl = $line.git" >> ../deploy.settings

echo ">>>>>>>>>>>(2/4)>>>>>>>>>>>>>>>>>"
echo "告诉我你的groupId，例如：com.yat3s.library"
read line
echo "groupId = $line" >> ../deploy.settings

echo ">>>>>>>>>>>(3/4)>>>>>>>>>>>>>>>>>"
echo "接着告诉我你的项目名称吧，例如：NineOldAndroid"
read line
echo "name = $line" >> ../deploy.settings
bintrayRepoName=$line

echo ">>>>>>>>>>>(4/4)>>>>>>>>>>>>>>>>>"
echo "最后告诉我你的版本吧，例如：1.0.0"
read line
echo "version = $line" >> ../deploy.settings

## Add deploy.gradle
cat>deploy.gradle<<EOF
apply plugin: 'com.github.dcendents.android-maven'
apply plugin: 'com.jfrog.bintray'

def artifact = new Properties()
artifact.load(new FileInputStream("deploy.settings"))

group = artifact.groupId
version = artifact.version

install {
    repositories.mavenInstaller {
        pom.project {
            packaging 'aar'
            groupId artifact.groupId
            name artifact.name
            url artifact.siteUrl
            licenses {
                license { // HARDCODED
                    name 'The Apache Software License, Version 2.0'
                    url 'http://www.apache.org/licenses/LICENSE-2.0.txt'
                    distribution 'repo'
                }
            }
            scm {
                connection artifact.gitUrl
                developerConnection artifact.gitUrl
                url artifact.siteUrl
            }
        }
    }
}

Properties properties = new Properties()
properties.load(project.rootProject.file('bintray.properties').newDataInputStream())

bintray {
    user = properties.getProperty("bintray.user")
    key = properties.getProperty("bintray.apikey")

    configurations = ['archives']
    pkg {
        repo = "maven"
        name = artifact.name
        websiteUrl = artifact.siteUrl
        vcsUrl = artifact.gitUrl
        licenses = ['Apache-2.0']
        publish = true
    }
}

task sourcesJar(type: Jar) {
    from android.sourceSets.main.java.srcDirs
    classifier = 'sources'
}

task javadoc(type: Javadoc) {
    source = android.sourceSets.main.java.srcDirs
    classpath += project.files(android.getBootClasspath().join(File.pathSeparator))
}

task javadocJar(type: Jar, dependsOn: javadoc) {
    classifier = 'javadoc'
    from javadoc.destinationDir
}

artifacts {
    archives javadocJar
    archives sourcesJar
}
EOF

echo "apply from: 'deploy.gradle'" >> build.gradle


## Add dependencise to project bulid.gradle
cd ../
sed -i -e '/dependencies {/a\
classpath "com.jfrog.bintray.gradle:gradle-bintray-plugin:1.2";  classpath "com.github.dcendents:android-maven-gradle-plugin:1.3"
' build.gradle &&

rm build.gradle-e

./gradlew install &&

./gradlew bintrayUpload &&
echo "上传成功，是否立即打开你的bintray项目主页(y/n)"
read line
if [ $line = "y" ];
then
open https://bintray.com/${bintrayUser}/maven/${bintrayRepoName}
fi
