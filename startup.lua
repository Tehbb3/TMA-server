print("TMA INSTALL SCRIPT")

-- disabled by default to prevent dev annoyances
exit()

shell.run('rm', '/tma/*') -- clear possible old installs
shell.run('mkdir', '/tma/') -- make dir

shell.run('cp', '/disk/*', '/tma') -- coppy files from disk

-- enable a file to run on startup from install


shell.run('cp', '/tma/slaveStartup', '/startup')


