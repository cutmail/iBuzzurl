SCHEME = "BuzzurlTouch"
WORKSPACE = "Buzzurl\\ touch.xcworkspace"
CONFIGURATION = "Debug"

DESTINATIONS = ["name=iPhone Retina (3.5-inch),OS=7.1",
                "name=iPhone Retina (4-inch),OS=7.1",]

task :default => [:clean, :test]
 
desc "clean"
task :clean do
  sh "xcodebuild clean | xcpretty -c"
end
 
desc "run unit tests"
task :test do
  DESTINATIONS.each do |destination|
    sh "xcodebuild test -scheme #{SCHEME} -destination \"#{destination}\" -workspace #{WORKSPACE} -configuration #{CONFIGURATION} | xcpretty -c"
  end
end

