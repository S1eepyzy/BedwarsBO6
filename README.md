# BedWars 极速轮换攻防 BO6（v1.0.0 · Minecraft 1.8.9）

基于 PLAN 文档实现的第一版可运行插件：1v1 / 2v2 / 3v3 满编自动开局、BO6 强制轮换攻防、每小局 2 次 5 秒复活、
基地只刷铁金（提速 30%）、钻石仅击杀掉落、团队升级全局永久、四种存储模式可切换、四场景计分板、全套 DEBUG 指令。

---

## 一、环境要求

| 项目 | 要求 |
|---|---|
| 服务端 | Spigot / Paper **1.8.8**（客户端 1.8.9） |
| JDK | **Java 8**（编译 target 1.8，请用 JDK 8 / 11 的 SDK，不要用 JDK 25 构建） |
| 构建 | Maven（IDEA 直接打开 `pom.xml` 即可） |

> 依赖会自动从 Spigot 仓库与 Maven Central 拉取（首次构建需联网）。

## 二、构建与安装

```bash
# 命令行构建（需要 Maven）
mvn clean package
```

IDEA：打开项目 → Maven 面板 → `package`，产物在 `target/BedWarsBO6-1.0.0.jar`。

安装：把 jar 丢进服务端 `plugins/`，启动一次生成配置，然后按第三节配置竞技场。

## 三、首次配置（必须做）

1. 进服后会传送到 `config.yml → lobby` 配置的大厅点（默认主世界 0,64,0），手上会有指南针（右键打开档位选择）。
2. 创建竞技场（需要 OP）：

```text
/bw arena create arena1 1v1
/bw arena setcenter arena1               # 中心拼刀区 / 等待区
/bw arena setspectator arena1            # 观战点
/bw arena setspawn arena1 red            # 红队出生点
/bw arena setspawn arena1 blue           # 蓝队出生点
/bw arena setbed   arena1 red            # 红队床点（头床位置）
/bw arena setbed   arena1 blue           # 蓝队床点
/bw arena addgen   arena1 iron           # 站在生成器位置执行（可多次）
/bw arena addgen   arena1 gold
/bw arena save
/bw arena info arena1                    # 检查是否“完整=是”
```

3. 多个竞技场可并存；`mode` 设为 `ALL` 表示三档通用，设为 `1v1/2v2/3v3` 表示专用。

## 四、玩法与规则实现说明

| 规则 | 实现 |
|---|---|
| 档位 | 仅 1v1(2人) / 2v2(4人) / 3v3(6人)，无 4v4 |
| 开局 | 满编自动触发 10s 倒计时；期间有人退出立即销毁倒计时并重置 |
| 选边 | 1v1 随机硬币；2v2/3v3 中心 60s 空手拼刀（禁方块/道具/弓箭/药水），击杀多者获得首局身份选择权（15s 未选自动默认进攻） |
| 攻防轮换 | 每小局结束**强制互换**，与胜负无关，打满 6 局双方各 3 攻 3 守 |
| 复活 | 每小局每人固定 2 次，5 秒复活；耗尽变旁观者；新小局强制重置为 2 次 |
| 资源 | 基地生成器只刷铁/金，间隔 = 基准 tick ÷ 1.3（提速 30%）；`base_spawn_diamond=false` 时永不刷钻 |
| 钻石 | 唯一来源为击杀敌方掉落（1v1=2 / 2v2=3 / 3v3=4） |
| 装备 | 死亡瞬间清空背包+盔甲（仅保留永久战靴与团队升级） |
| 团队升级 | 速度 / 防御 / 再生 / 急迫，钻石购买，整场 BO6 永久保存，跨小局与死亡不丢失 |
| 夺冠 | 先到 4 分立即结束；6 局打完 3-3 进入加时（下一小局胜者直接夺冠） |

**单小局胜负判定（PLAN 未明确规定，本版按以下规则实现，可在 config 调整时限）**

1. 进攻方摧毁**防守方的床** → 进攻方 +1（每小局只在防守方基地生成床，进攻方无床）
2. 某队全员复活次数耗尽 → 对方 +1
3. 单局时间耗尽（`basic.round_time_limit`，默认 300s）→ 防守方 +1

## 五、指令

| 指令 | 说明 |
|---|---|
| `/bw` / `/bw help` | 帮助 |
| `/bw join <1v1\|2v2\|3v3>` | 加入房间 |
| `/bw leave` | 离开房间 |
| `/bw shop` | 物品商店（铁/金/钻石）→ 内含“团队升级”入口 |
| `/bw choose <attack\|defend>` | 选边阶段选择首局身份 |
| `/bw status` | 查看当前房间 / 全服房间 |
| `/bw arena ...` | 竞技场配置（管理员，见第三节） |
| `/bw db ...` | 存储调试（见第六节） |
| `/bw debug ...` | 对局调试（需 `debug.enable_debug_mode`） |
| `/bw reload` | 热重载全部配置 |

调试子指令：

```text
/bw debug start                 强制触发满编倒计时（无需满人）
/bw debug roundwin <red|blue>   强制判定当前小局胜方
/bw debug setscore <红分> <蓝分> 直接设置比分（测夺冠 / 加时）
/bw debug board                 查看当前计分板场景
/bw debug respawn               重置全员复活次数
```

## 六、存储（LOCAL / SQLITE / MYSQL / REDIS_CACHE）

改 `config.yml → database.storage_mode` 后 `/bw reload` 即可切换，**无需改代码**。

- **LOCAL（默认）**：`plugins/BedWarsBO6/data/` 下 `room.yml` / `player_temp.yml` / `team_upgrade.yml` / `score.yml`，定时落盘，文件损坏自动备份重建。
- **SQLITE / MYSQL**：表 `bw_room`、`bw_player_temp`、`bw_team_upgrade`、`bw_score_record`（MySQL 额外有 `server_id / create_time / update_time / is_finish`）。
- **REDIS_CACHE**：主存储用本地文件 + Redis 缓存实时数据；也可在任意模式下把 `enable_global_cache` 打开来启用 Redis。
- **兜底**：数据库连不上自动降级为 LOCAL 并打日志，不会禁用插件；Redis 缺失自动降级为内存缓存。

调试指令：

```text
/bw db test          测试连接 / 打印模式与耗时
/bw db readtest      读取校验（团队升级 / 计分 / 玩家临时数据条数）
/bw db writetest     写入 + 落盘 + 一致性校验
/bw db cache clear   清空缓存
/bw db migrate       YAML -> SQLite/MySQL 迁移
/bw db resetroom     重置全部房间临时数据
/bw db checkdata     全局脏数据校验（控制台输出明细）
/bw db fallback      手动降级为本地文件存储
```

## 七、DEBUG 分阶段自测（对应 PLAN 第四章）

| 阶段 | 操作 |
|---|---|
| 1 大厅/倒计时 | 切档位加人；未满编看计分板“等待补齐玩家”；满编触发 10s；倒计时中退出 1 人应立即重置 |
| 2 选边/轮换 | 1v1 看随机；2v2/3v3 拼刀计分；用 `/bw debug roundwin` 连打 6 局，核对每局攻防是否严格交替；`setscore 3 3` 验加时 |
| 3 复活 | 开局每人 2 次；死 2 次后变旁观者；新小局全员重置为 2 |
| 4 资源 | 挂机看基地只出铁金（速度约为原版 1.3 倍）；击杀敌人掉钻 |
| 5 装备/升级 | 买装备后死亡应清空；买团队升级后跨小局、跨轮换、死亡都不丢 |
| 6 计分/结束 | 4 分立即结束并弹结算；3-3 进加时 |
| 7 边界 | 中途退出不终止对局；单队全退对面整场胜利；倒计时期间房间锁定；`/bw db checkdata` 无脏数据 |

## 八、目录结构

```text
src/main/java/com/bwbo6/
├─ BedWarsBO6.java              主类 / 生命周期 / 热重载
├─ config/                      ConfigManager（强类型配置）、MessageManager
├─ util/                        TextUtil、ItemUtil、BedUtil（1.8 床方块处理）
├─ debug/                       Debugger（分级日志）、DataChecker（脏数据校验）
├─ storage/                     StorageManager + LOCAL/SQLITE/MYSQL 驱动 + Redis/内存缓存
├─ game/                        Room（状态机）、GameManager、RespawnManager、
│                               ResourceManager、UpgradeManager、SideChooser
├─ arena/                       Arena、ArenaManager
├─ board/                       ScoreboardManager（4 场景 2tick 增量刷新）
├─ shop/                        ShopManager（物品商店 + 团队升级）
├─ listener/                    连接 / 战斗 / 场地 / GUI / 交互
└─ command/                     BWCommand、ArenaCommand、DebugCommand
```

核心函数（PLAN 第八章）位置：`Room#checkFullPlayer`、`Room#startLobbyCountdown`、`Room#cancelCountdownTask`、
`SideChooser#chooseFirstSide`、`Room#swapAttackDefend`、`RespawnManager#resetAll`、`Room#clearPlayerEquipment`、
`UpgradeManager#save/load`、`ResourceManager#dropKillDiamond`、`ScoreboardManager#updateRoom`、
`Room#checkGameWin`、`Room#roundEndReset`、`DataChecker#checkRoom`。

## 九、已知限制（第一版）

- 商店通过 `/bw shop` 打开（未做 NPC 村民），可在后续版本加基地商店 NPC。
- 竞技场不做地形回滚，小局结束时按“玩家放置方块记录”清除并清空掉落物。
- 资源生成器为固定点位（不走 Hypixel 的队伍共享池逻辑）。
