[13:39:36 INFO]: [BedWarsBO6] Enabling BedWarsBO6 v2.1.1
[13:39:36 WARN]: [BedWarsBO6] Could not save config.yml to plugins\BedWarsBO6\config\config.yml because config.yml already exists.
[13:39:36 WARN]: [BedWarsBO6] Could not save arenas.yml to plugins\BedWarsBO6\config\arenas.yml because arenas.yml already exists.
[13:39:36 WARN]: [BedWarsBO6] Could not save scoreboard.yml to plugins\BedWarsBO6\config\scoreboard.yml because scoreboard.yml already exists.
[13:39:36 WARN]: [BedWarsBO6] Could not save shop.yml to plugins\BedWarsBO6\content\shop.yml because shop.yml already exists.
[13:39:36 WARN]: [BedWarsBO6] Could not save messages.yml to plugins\BedWarsBO6\content\messages.yml because messages.yml already exists.
[13:39:37 WARN]: [BedWarsBO6] Could not save menus.yml to plugins\BedWarsBO6\content\menus.yml because menus.yml already exists.
[13:39:37 WARN]: [BedWarsBO6] Could not save enchant.yml to plugins\BedWarsBO6\content\enchant.yml because enchant.yml already exists.
[13:39:37 WARN]: [BedWarsBO6] Could not save npcs.yml to plugins\BedWarsBO6\content\npcs.yml because npcs.yml already exists.
[13:39:37 INFO]: [BedWarsBO6] [DATA] [LOCAL] 初始化完成 dir=E:\bedwars bo6\服务器\.\plugins\BedWarsBO6\data
1.修改这个问题 
[13:45:17] [User Authenticator #1/INFO]: UUID of player S1eepyZy is 579aff5b-032d-33dc-9ef3-b71c8a92419f
[13:45:17] [Server thread/INFO]: S1eepyZy[/127.0.0.1:61656] logged in with entity id 33 at ([world]-20.5, 70.0, 9.5)
[13:45:17] [Server thread/ERROR]: [BedWarsBO6] [DEBUG] 计分板刷新异常: S1eepyZy -> NullPointerException: Cannot invoke "org.bukkit.configuration.file.FileConfiguration.getString(String, String)" because "this.cfg" is null
[13:45:17] [Server thread/WARN]: [BedWarsBO6] Task #6 for BedWarsBO6 v2.1.1 generated an exception
java.lang.NullPointerException: Cannot invoke "org.bukkit.configuration.file.FileConfiguration.getString(String, String)" because "this.cfg" is null
	at com.bwbo6.board.ScoreboardManager.update(ScoreboardManager.java:111) ~[?:?]
	at com.bwbo6.game.GameManager.toLobby(GameManager.java:224) ~[?:?]
	at com.bwbo6.listener.PlayerConnectionListener$1.run(PlayerConnectionListener.java:30) ~[?:?]
	at org.bukkit.craftbukkit.v1_8_R3.scheduler.CraftTask.run(CraftTask.java:65) ~[server.jar:]
	at org.bukkit.craftbukkit.v1_8_R3.scheduler.CraftScheduler.mainThreadHeartbeat(CraftScheduler.java:403) ~[server.jar:]
	at com.windpvp.windspigot.world.WorldTickManager.tickWorlds(WorldTickManager.java:72) ~[server.jar:]
	at com.windpvp.windspigot.world.WorldTickManager.tick(WorldTickManager.java:43) ~[server.jar:]
	at net.minecraft.server.v1_8_R3.MinecraftServer.B(MinecraftServer.java:1080) ~[server.jar:]
	at net.minecraft.server.v1_8_R3.DedicatedServer.B(DedicatedServer.java:450) ~[server.jar:]
	at net.minecraft.server.v1_8_R3.MinecraftServer.A(MinecraftServer.java:951) ~[server.jar:]
	at net.minecraft.server.v1_8_R3.MinecraftServer.run(MinecraftServer.java:722) ~[server.jar:]
	at net.minecraft.server.v1_8_R3.MinecraftServer.lambda$spin$0(MinecraftServer.java:156) ~[server.jar:]
	at java.lang.Thread.run(Thread.java:1474) ~[?:?]
[13:45:17] [Server thread/ERROR]: [BedWarsBO6] [DEBUG] 计分板刷新异常: S1eepyZy -> NullPointerException: Cannot invoke "org.bukkit.configuration.file.FileConfiguration.getString(String, String)" because "this.cfg" is null
[13:45:17] [Server thread/ERROR]: [BedWarsBO6] [DEBUG] 计分板刷新异常: S1eepyZy -> NullPointerException: Cannot invoke "org.bukkit.configuration.file.FileConfiguration.getString(String, String)" because "this.cfg" is null
[13:45:17] [Server thread/ERROR]: [BedWarsBO6] [DEBUG] 计分板刷新异常: S1eepyZy -> NullPointerException: Cannot invoke "org.bukkit.configuration.file.FileConfiguration.getString(String, String)" because "this.cfg" is null
[13:45:17] [Server thread/ERROR]: [BedWarsBO6] [DEBUG] 计分板刷新异常: S1eepyZy -> NullPointerException: Cannot invoke "org.bukkit.configuration.file.FileConfiguration.getString(String, String)" because "this.cfg" is null
[13:45:18] [Server thread/ERROR]: [BedWarsBO6] [DEBUG] 计分板刷新异常: S1eepyZy -> NullPointerException: Cannot invoke "org.bukkit.configuration.file.FileConfiguration.getString(String, String)" because "this.cfg" is null
[13:45:18] [Server thread/ERROR]: [BedWarsBO6] [DEBUG] 计分板刷新异常: S1eepyZy -> NullPointerException: Cannot invoke "org.bukkit.configuration.file.FileConfiguration.getString(String, String)" because "this.cfg" is null
[13:45:18] [Server thread/ERROR]: [BedWarsBO6] [DEBUG] 计分板刷新异常: S1eepyZy -> NullPointerException: Cannot invoke "org.bukkit.configuration.file.FileConfiguration.getString(String, String)" because "this.cfg" is null
[13:45:18] [Server thread/ERROR]: [BedWarsBO6] [DEBUG] 计分板刷新异常: S1eepyZy -> NullPointerException: Cannot invoke "org.bukkit.configuration.file.FileConfiguration.getString(String, String)" because "this.cfg" is null
[13:45:18] [Server thread/ERROR]: [BedWarsBO6] [DEBUG] 计分板刷新异常: S1eepyZy -> NullPointerException: Cannot invoke "org.bukkit.configuration.file.FileConfiguration.getString(String, String)" because "this.cfg" is null
2.这个已知bug
3.npc会到处乱跑
4.物品商店不显示东西
5.选择对局的菜单死亡会掉落
6.bwb arena创建的地方有问题 我都说了 队伍只有att def att没有床 但是你让都设置
7.然后在修改一下你修的mainlobby的功能不起作用 玩家进入服务器之后会卡在地里 死一次才在我设置的点上 然后输入hub返回mainlobby的功能也要