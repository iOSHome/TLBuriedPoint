use_frameworks!

project 'TLBuriedPoint.xcodeproj'

target :TLBuriedPoint do
  platform :ios, '8.0'
  pod 'MLeaksFinder', '~> 1.0.0'
  pod 'Mantle', '<= 1.5'
  pod 'Masonry', '~> 1.0.1'
  pod 'Aspects', '~> 1.4.1'
  pod 'RegexKitLite-NoWarning', '1.1.0'
  
end


# iOS Pod集成移动监控引入FBRetainCycleDetector的问题处理
post_install do|installer|
   #解决问题一
   find_and_replace("Pods/FBRetainCycleDetector/FBRetainCycleDetector/Layout/Classes/FBClassStrongLayout.mm",
       "layoutCache[currentClass] = ivars;", "layoutCache[(id)currentClass] = ivars;")
   #解决问题二
   find_and_replace("Pods/FBRetainCycleDetector/fishhook/fishhook.c",
   "indirect_symbol_bindings[i] = cur->rebindings[j].replacement;", "if (i < (sizeof(indirect_symbol_bindings) /
        sizeof(indirect_symbol_bindings[0]))) { \n indirect_symbol_bindings[i]=cur->rebindings[j].replacement; \n }")
end
def find_and_replace(dir, findstr, replacestr)
  Dir[dir].each do |name|
    FileUtils.chmod("+w",name) #add
      text = File.read(name)
      replace = text.gsub(findstr,replacestr)
      if text != replace
         puts "Fix: " + name
         File.open(name, "w") { |file| file.puts replace }
         STDOUT.flush
      end
  end
  Dir[dir + '*/'].each(&method(:find_and_replace))
end
