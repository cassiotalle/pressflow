@arq = File.read('.gitignore').split("\n")
@arq.each do |command_line|
    system("git rm -r --cached #{command_line}")
end

