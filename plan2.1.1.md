1.把enchant.yml和enchantmanager的修改成hypixel一模一样的 就比如 只有锋利 保护 陷阱 然后最重要的是 不能自己附魔 是拿钻石去找团队升级商人去升级 锋利只有一级 保护可以升到4级 陷阱 买第一个陷阱只需要一个钻石 但是第二个就是要2个钻石 后续依次叠加 但是陷阱最多只能4个 你设计的没错 不需要修改 只需要修改只保留锋利 保护 陷阱 剩下的其余都删除 所以你的那个menu也得重做
2./bw arena import <zip文件> 这个你写的代码在arenacommand但是我前面说过指令前缀都是/bwb 而且import后面直接接文件夹 而不是zip文件 zip文件你又不会自己解压
3.一个生成npc的指令 生成完npc可以选择他是哪个菜单的指令 然后每把打完回到mianlobby 所以我还需要一个色织setmainlobby的指令 setwaitlobby是等待大厅 这俩也修改一下
4. 告诉我怎么测试出bug 然后在修复一下所有工作区出现的bug 先完成写的指令在修复bug 版本是2.1.1现在

---

# ✅ v2.1.1 实现完成记录（2026-09-05）

## 1. Hypixel 团队升级（锋利 / 保护 / 陷阱）—— 已重做
- `enchant.yml`：只保留 `sharpness_1`(锋利I) 与 `protection_1~4`(保护I~IV)、唯一陷阱 `trap`；删除击退/火焰附加/力量/击退棒/效率/挖掘疲劳及 speed/defense/regen/haste 等全部旧条目。
- **不能自己附魔**：`EnchantManager` 移除"手持附魔"入口，出生木剑不再自带锋利。
- 玩法通道：基地团队升级商人 NPC / `/bwb upgrade` / 物品商店"团队升级"页，全部打开**同一个升级商人菜单**。
- 全队生效：锋利 I 作用于全队剑；保护按级作用于全队护甲；购买/重生/商店买装/重连都会自动补附魔（`UpgradeManager.apply`）。
- 陷阱：唯一"团队陷阱"，价格递增 = 队列数+1（1/2/3/4 钻），最多 4 个；敌人进基地触发即消耗，效果=失明+缓慢；`Team` 陷阱改为 `trapCount`。
- 每小局结束自动重置（`resetRoundState`）。

## 2. 地图导入 —— 已改
- 命令统一为 `/bwb arena import <地图文件夹或zip> [世界名] [档位]`：import 后**直接接文件夹名**即可（文件夹优先），zip 仍自动解压；help/usage/tab 同步为 /bwb。

## 3. NPC 与大厅 —— 已新增
- `/bwb npc spawn <shop|upgrade|rejoin|leave> [名字]`：在脚下生成指定菜单的 NPC（生成后可指定归属哪个菜单）。
- `/bwb npc type <shop|upgrade|rejoin|leave> [名字]` 改最近 NPC；`remove`/`list` 管理。
- NPC 类型新增 `UPGRADE`＝团队升级商人；修复 npcs.yml 持久化(list/section 兼容 + name 字段)。
- `/bwb setwaitlobby`（原 setlobby，等待大厅）与 `/bwb setmainlobby`（主大厅）；**每把 BO6 打完结算自动回 mainlobby**（未设置回退等待大厅）。config 新增 `main_lobby` 段。

## 4. 版本
- pom.xml + plugin.yml 均为 **2.1.1**。
- 全量 javac 编译通过（含 DataChecker 适配新升级类型）。

## 如何测试（重点看这 4 块）
1. 升级商人：开局→击杀得钻→买陷阱1(1钻)/2(2钻)/3(3钻)/4(4钻)、第5次应提示已满；敌人进基地触发失明+缓慢且陷阱-1；买保护I→护甲Lv1、再买II…IV；锋利I全队剑有锋利、商店新买剑也带。
2. 换小局后升级/陷阱清空；死亡复活后剑/护甲仍有团队附魔。
3. `/bwb arena import 你的地图文件夹` 能导入；`/bwb` 帮助全为 bwb 前缀。
4. NPC：生成→重进服务器不消失（npcs.yml 持久化）→点击能开对应菜单；一局打完后玩家回到 setmainlobby 的位置。