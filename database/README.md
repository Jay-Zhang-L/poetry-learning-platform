# 数据库快照与导入

`shici-full.sql` 由作者通过 DataGrip 调用 MySQL `mysqldump` 导出，包含 `shici` 数据库的表结构与现有数据。作者确认其中数据为虚拟演示数据，并授权随项目公开；本仓库保留导出文件原样。

| 项目 | 内容 |
| --- | --- |
| 导出时间 | 2026 年 10 月 15 日 |
| MySQL / mysqldump 版本 | 8.0.43 |
| 字符编码 | UTF-8 |
| 文件大小 | 638,963 字节，约 624 KiB |
| 建表数量 | 81 张 |
| 包含 INSERT 语句的表 | 53 张 |
| 导出完整性标记 | 文件末尾包含 `Dump completed` |

表数量与插入语句按 SQL 文本统计，不代表已经重新导入或通过应用联调。答辩材料中的约 33.8 万首诗词为材料口径，当前快照的具体内容以文件为准。

## 导入前

准备 MySQL 8 环境，并使用**新建的空数据库**。文件包含 `DROP TABLE IF EXISTS`，导入时会重建目标数据库内的同名表。已有项目数据请使用另外的空库导入。

快照未包含 `CREATE DATABASE` 或 `USE` 语句，需要先创建并选定目标数据库。以下示例使用与本地配置一致的库名 `shici`；使用其他名称时同步设置后端的 `DB_URL`。

## 在 DataGrip 中导入

1. 连接 MySQL，新建空数据库 `shici`，字符集使用 `utf8mb4`。
2. 打开 `shici-full.sql`，将文件执行目标设为该空数据库。
3. 执行整个 SQL 文件，等待结束并确认没有导入错误。
4. 刷新数据库目录，确认导入了 81 张表。
5. 根据[运行指南](../docs/getting-started.md)设置数据库账号、密码及外部服务，启动后端与前端。

如本机已有需要保留的 `shici` 库，请新建另一个空库并选择该库执行，再将后端 `DB_URL` 改为该库名。

## 使用 MySQL 命令行导入

在仓库根目录启动 MySQL 客户端，使用自己的数据库账号；`-p` 会交互式提示输入密码：

```bash
mysql --default-character-set=utf8mb4 -u root -p
```

在 MySQL 提示符中依次执行：

```sql
CREATE DATABASE shici CHARACTER SET utf8mb4;
USE shici;
SOURCE database/shici-full.sql;
SHOW TABLES;
```

若 `CREATE DATABASE` 提示库已存在，请先为本次导入另选一个空库名，再执行后续步骤。`SOURCE` 路径相对于启动客户端时的目录；也可替换为本机 SQL 文件的绝对路径，Windows 下建议使用 `/`。

## 快照范围

SQL 包含建表语句与导出时的数据库记录，不包含数据库记录所引用的磁盘文件。诗词配图、上传图片、录音、视频、OCR 服务及模型文件需要按实际目录另行配置。

快照中的演示账户和社交记录用于展示，部署者应自行创建自己的运行账号。项目的第三方 AI / 语音服务凭据通过环境变量配置，参见[本地运行指南](../docs/getting-started.md)。
