## 使用 (如果你坚持使用 KlustaKwik 的话)

1. 目前 klustakwik_Windows 还没经过验证可用, 至少对于较大的 amplifier.dat 文件无法正常运行
2. 建议在 linux 或 WSL 上运行 klustakwik_Linux 中的脚本 (linux 中可以运行 .m 或 .py 脚本, wsl 中可以运行 .py 脚本)
3. phy2-plugins 还未测试使用方法

## TODO

1. 用 SpikeInterface 替代 ndmanager 插件中的 filter 和 spike detector
2. 干脆用 SpikeInterface 中的 klusta 或其他 spike sorter 替代 KlustaKwik (主要是真没人带 KlustaKwik 玩了...)