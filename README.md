# 🛡️ Stress Lab - 仮想化インフラベースのセキュリティ診断自動化・統合管理システム

VMware仮想化環境上のLinuxサーバーとKali Linuxノードを安全に接続し、ネットワーク負荷テスト、ポートスキャン、リアルタイムリモートターミナル制御を提供する**統合セキュリティインフラ・管理プラットフォーム**です。

Webブラウザからネットワークポートスキャン、ネットワーク負荷テスト、Kali Linuxリモートターミナル、脆弱性情報（CVE）の照会、会員管理、掲示板などの機能を一つのWebインターフェースから利用できるように実装しました。

単なるWeb機能の実装にとどまらず、**仮想ネットワーク分離、ファイアウォール(UFW)アクセス制御、SSH/JSchによるセキュアなホスト間通信**を前提としたインフラアーキテクチャを設計・構築しています。

> ⚠️ **注意事項**
> 本プロジェクトは、セキュリティ学習および認可されたテスト環境内での検証を目的として構築されています。
> 負荷テストやポートスキャン、リモートコマンド実行機能は、自組織が管理する検証用ネットワークおよび明示的な許可を得たターゲットに対してのみ実行されます。

---

## 📌 インフラ・システム概要

ホストマシン上のVMware環境にWeb/App/DB統合ノードおよびセキュリティ検証ノード(Kali Linux)を配置し、セキュアな内部ネットワーク経由で診断タスクを制御する構成をとっています。

### 主要インフラ・セキュリティ機能
- **仮想ネットワーク構築 & パケット制御**: VMware仮想アダプター(`eth0`)および特定ポートベースの通信制御
- **ファイアウォール(UFW)アクセス制御**: 22(SSH), 80/443(Web), 3306(MariaDB), 53(DNS)の最小権限ポート設計
- **セキュアリモート通信**: JSchライブラリを用いたSSHセッション管理およびコマンド実行制御
- **WebSocket双方向通信**: ブラウザとLinux Shell間のリアルタイムターミナルストリーミング
- **ネットワークセキュリティ診断**: Nmapエンジン連動によるポート・サービススキャン
- **負荷耐性テスト**: Kali Linuxの`hping3`を用いたパケット負荷テスト(SYN/UDP/ICMP/ACK)
- **脆弱性データ統合**: CVEメタデータのDB格納および検索管理

### 主要アプリケーション機能
- 🔐 会員登録 / ログイン / パスワード変更 / 会員情報の変更 / 会員退会
- 📢 お知らせ掲示板（CRUD・タイトル/内容検索・ページネーション・投稿権限確認）
- 🔍 Nmapによるプロファイル別ポートスキャン
- 📊 ネットワーク負荷テストUI（パケット種別・カウント・宛先制御）
- 🖥️ Kali Linuxリモートターミナル（リアルタイムログ表示・クリアコマンド対応）
- 🛡️ CVE / 脆弱性情報管理（CVSSスコア、影響度、ベンダ情報照会）

---

## 🖥️ インフラストラクチャ & ネットワーク構成

本システムは、各コンポーネントが役割に応じた通信ポートのみを許可するネットワークアクセス制御を行っています。

```text
[ Client (Web Browser) ]
           │
           │ HTTP (Port 80) / HTTPS (Port 443) / WebSocket
           ▼
┌─────────────────────────────────────────────────────────────┐
│  VMware Virtual Machine (Linux Node : 192.168.0.25)         │
│                                                             │
│  [ Firewall (UFW) Access Control ]                          │
│  - 80/tcp, 443/tcp : Web Application Access                 │
│  - 22/tcp          : SSH Remote Administration              │
│  - 3306/tcp        : Database Internal Binding              │
│  - 53              : Name Resolution                        │
│                                                             │
│  ┌─────────────────────────┐     ┌────────────────────────┐ │
│  │ Apache Tomcat Engine    │     │ MariaDB Database       │ │
│  │ (Servlet / WebSocket)   │────▶│ (User / CVE / Logs)    │ │
│  │                         │JDBC │ Port: 3306             │ │
│  └────────────┬────────────┘     └────────────────────────┘ │
└───────────────┼─────────────────────────────────────────────┘
                │
                │ SSH Protocol (Port 22 / JSch Channel)
                ▼
┌─────────────────────────────────────────────────────────────┐
│  Security Testing Node (Kali Linux Environment)             │
│                                                             │
│  - Nmap (Service Detection, Script Engine)                  │
│  - hping3 (Packet Generation, Traffic Load Test)            │
│  - Remote Interactive Shell Execution                       │
└─────────────────────────────────────────────────────────────┘
```

---

## ⚙️ インフラ環境 & 技術スタック

| レイヤー | 採用技術・環境 | 役割・詳細 |
|---|---|---|
| **Virtualization** | VMware Workstation / ESXi | 仮想マシン分離および仮想ネットワーク(NAT/Host-only)構築 |
| **OS / Server** | Linux (Ubuntu/Debian系) | サーバー基盤、`eth0` (192.168.0.25) インターフェース構成 |
| **Network Security** | UFW (Uncomplicated Firewall) | 22, 53, 80, 443, 3306 ポートへの厳密なトラフィック制御 |
| **Security Testing** | Kali Linux, Nmap, hping3 | ネットワークスキャンおよびトラフィック負荷生成ノード |
| **Remote Protocol** | SSH, JSch (Java SSH API) | 暗号化チャネルを通じたリモートコマンド実行およびセッション管理 |
| **Web / Runtime** | Apache Tomcat 9+, Java 17+ | コントローラー、WebSocketエンドポイント、ビジネスロジック |
| **Database** | MariaDB | 認証情報、監査ログ、CVE脆弱性データの永続化 (Port: 3306) |
| **DBアクセス** | JDBC (DAO / DTO パターン) | コネクション管理およびデータ永続化処理 |
| **フロントエンド** | JSP, HTML5, CSS3, JavaScript | 管理・テスト実行用Webダッシュボード |
| **CSS Framework** | Tailwind CSS | レスポンシブUI構築 |
| **Realtime Stream** | WebSocket API | ターミナルログおよびテスト進行状況のリアルタイムストリーミング |
| **開発環境 / ビルド** | Eclipse | Eclipse Dynamic Web Project |

---

## 🔒 セキュリティ制御 & ハードニング設計

本環境では、不用意な外部露出を防ぎ、安全な検証環境を維持するために以下の設定を適用しています。

### 1. ファイアウォール(UFW)のポート開放ポリシー
不要なポートをすべて遮断し、サービス稼働に必要な最小限のポートのみを明示的に開放。

```text
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere (リモート管理用)
53                         ALLOW       Anywhere (DNS名前解決)
3306/tcp                   ALLOW       Anywhere (DBアクセス)
80/tcp                     ALLOW       Anywhere (HTTP Webサービス)
443/tcp                    ALLOW       Anywhere (HTTPS暗号化通信)
22/tcp (v6)                ALLOW       Anywhere (v6)
53 (v6)                    ALLOW       Anywhere (v6)
3306/tcp (v6)              ALLOW       Anywhere (v6)
80/tcp (v6)                ALLOW       Anywhere (v6)
443/tcp (v6)               ALLOW       Anywhere (v6)
```

### 2. リモート実行のセキュア化設計
- **通信路の暗号化**: 平文通信を排除し、すべてSSH暗号化トンネルを経由してKaliノードへコマンドを伝達。
- **入力値サニタイズ (OS Command Injection対策)**: Webインターフェースから入力されたIP/ポート引数に対し、正規表現による厳密なバリデーションを実施。
- **Allowlist制限**: 実行可能なバイナリを`nmap`および`hping3`に限定し、任意のシステム破壊コマンド実行を防止。
- **DBアクセス制御**: MariaDBを安全な内部ネットワークにバインドし、診断ツールノードとデータ保管ノードの役割を明確に分離。

---

## 🏗️ プロジェクト構造

```text
stress_lab/
├── infra/
│   └── ufw-rules.txt            # ファイアウォール設定およびネットワークアクセス定義
│
├── src/
│   └── main/
│       ├── java/
│       │   ├── common/
│       │   │   ├── AttackResult.java
│       │   │   ├── AttackService.java
│       │   │   ├── MariaDBConnection.java
│       │   │   ├── SSHUtil.java
│       │   │   └── WebSocket.java
│       │   │
│       │   ├── controller/
│       │   │   ├── member.java
│       │   │   ├── notice.java
│       │   │   └── stress.java
│       │   │
│       │   ├── dao/
│       │   │   ├── MemberDao.java
│       │   │   ├── NoticeDao.java
│       │   │   └── VulnerabilityDao.java
│       │   │
│       │   ├── dto/
│       │   │   ├── MemberDto.java
│       │   │   ├── NoticeDto.java
│       │   │   └── VulnerabilityDto.java
│       │   │
│       │   └── service/
│       │       ├── DDoSService.java
│       │       └── PortScanService.java
│       │
│       └── webapp/
│           ├── css/
│           │   └── styles.css
│           │
│           ├── stress/
│           │   ├── dashboard.jsp
│           │   ├── ddos.jsp
│           │   ├── footer.jsp
│           │   ├── index.jsp
│           │   ├── login.jsp
│           │   ├── mypage.jsp
│           │   ├── notice.jsp
│           │   ├── noticeEdit.jsp
│           │   ├── noticeView.jsp
│           │   ├── noticeWrite.jsp
│           │   ├── portscan.jsp
│           │   ├── sidebar.jsp
│           │   └── terminal.jsp
│           │
│           └── WEB-INF/
│               └── lib/
│
└── build/
```

---

## 🔄 MVC / DAO アーキテクチャ

本システムは、保守性と拡張性を考慮した従来型のJSP/Servletアーキテクチャをベースに実装しています。

```text
JSP (View)
 │
 ▼
Servlet Controller (Routing / Validation)
 │
 ▼
Service (Business Logic / Remote SSH Execution)
 │
 ▼
DAO (Data Access Object)
 │
 ▼
JDBC
 │
 ▼
MariaDB (Port: 3306)
```

- **Controller**: HTTPリクエストを処理し、入力バリデーション後に適切なServiceまたはDAOを呼び出し (`member.java`, `notice.java`, `stress.java`)
- **Service**: 負荷テスト・スキャンロジックの構築およびSSHUtilを通じた外部Linuxノードとの連携 (`PortScanService.java`, `DDoSService.java`)
- **DAO**: MariaDBに対するSQL実行およびトランザクション処理 (`MemberDao.java`, `NoticeDao.java`, `VulnerabilityDao.java`)
- **DTO**: 各層間におけるデータの受け渡し (`MemberDto.java`, `NoticeDto.java`, `VulnerabilityDto.java`)

---

## 🔎 診断機能 & 処理パイプライン

### 1. ネットワークスキャン (Nmap連携)

```text
Port Scan JSP ──▶ stress Servlet ──▶ PortScanService ──▶ SSHUtil (JSch) ──▶ Kali Linux (Nmap) ──▶ Scan Result
```

- **テストプロファイル**:
  - Full Scan
  - Fast Port Scan
  - Full Port Scan
  - Service Version Detection (`-sV`)
  - OS Detection (`-O`)
  - Vulnerability Script Scan (`--script vuln`)

`PortScanService`はテスト対象とスキャンオプションを受け取り、SSHトンネル経由でKali Linux上のNmapを実行して結果をパースします。

### 2. ネットワーク負荷テスト (hping3連携)

```text
DDoS JSP ──▶ JavaScript Fetch ──▶ stress Servlet ──▶ DDoSService ──▶ SSHUtil (JSch) ──▶ Kali Linux (hping3)
```

- **対応テストタイプ**: SYN, UDP, ICMP, ACK
- **設定項目**: Target IP, Destination Port, Packet Count, Delay, Random Source IP

### 3. Kali Linuxリモートターミナルエミュレーション

```text
Browser ──(WebSocket)──▶ Tomcat WebSocket ──(SSH / JSch)──▶ Kali Linux Shell
```

- WebSocketによる双方向リアルタイム通信
- SSHセッションの動的管理と標準入出力バインディング
- ターミナルログの自動スクロールおよび`clear`コマンド対応

---

## 🗄️ データモデル & スキーマ設計 (MariaDB)

### Member (認証・管理)

```sql
id           VARCHAR(50) PRIMARY KEY,
name         VARCHAR(100) NOT NULL,
password     VARCHAR(255) NOT NULL,
email        VARCHAR(100) NOT NULL,
created_at   DATETIME DEFAULT CURRENT_TIMESTAMP
```

### Notice (お知らせ掲示板)

```sql
notice_id    INT AUTO_INCREMENT PRIMARY KEY,
writer_id    VARCHAR(50) NOT NULL,
title        VARCHAR(255) NOT NULL,
content      TEXT NOT NULL,
view_count   INT DEFAULT 0,
created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```

### Vulnerability (CVEメタデータ管理)

```sql
id             INT AUTO_INCREMENT PRIMARY KEY,
cve_id         VARCHAR(50) UNIQUE NOT NULL,
title          VARCHAR(255) NOT NULL,
description    TEXT,
severity       VARCHAR(20),
cvss_score     DECIMAL(3,1),
vendor         VARCHAR(100),
product        VARCHAR(100),
published_date DATE,
reference_url  VARCHAR(255),
created_at     DATETIME DEFAULT CURRENT_TIMESTAMP
```

---

## 🚀 実行手順 & セットアップ

### 必要要件
- JDK 17+
- Apache Tomcat 9+
- MariaDB 10+
- VMware Workstation / ESXi
- Kali Linux（SSHサーバー、Nmap、hping3インストール済み）

### 基本セットアップ
1. MariaDBを起動し、プロジェクト用DBおよび各テーブルを作成
2. `MariaDBConnection.java`にて接続情報（Host, Port, User, Password）を設定
3. Kali LinuxノードでSSHサービスを起動（`sudo systemctl start ssh`）
4. TomcatサーバーにWARファイルをデプロイ、またはEclipseから実行
5. ブラウザより管理ダッシュボード（`http://192.168.0.25:8080/stress_lab/`）へアクセス

---

## 📚 学習・技術検証実績

- **インフラ・ネットワーク**: VMware仮想ネットワーク構築、UFWファイアウォール設計、ホスト間アクセス制御
- **セキュリティエンジニアリング**: Nmapスキャンプロファイル設計、hping3負荷検証、OS Command Injection対策設計
- **バックエンド・プロトコル**: Java Servlet/JSP、MVC/DAOパターン、JDBC、JSchによるSSHトンネリング、WebSocketリアルタイム通信
- **データ管理**: CVEメタデータ設計、リレーショナルデータモデル構築、Sessionベース認証管理

---

## 📝 プロジェクト進捗 & クラウド移行ロードマップ

### 実装済み (Completed)
- [x] VMware上のLinuxサーバーおよびUFWファイアウォール構築
- [x] 会員登録 / ログイン / パスワード・情報変更
- [x] お知らせCRUD / 検索 / ページネーション
- [x] CVE脆弱性情報管理・照会
- [x] SSH (JSch) によるKali Linuxリモート連携
- [x] Nmapポート・サービススキャン機能
- [x] hping3ネットワーク負荷テスト機能
- [x] WebSocketによるリアルタイムターミナル制御

### 今後の改善 & クラウド移行計画 (Roadmap)
- [ ] パスワードのArgon2/BCryptハッシュ化
- [ ] コマンド実行Allowlistの厳格化
- [ ] **Dockerコンテナ化**: Tomcatおよびテストエンジンのコンテナ化 (Docker Compose)
- [ ] **AWS環境への移行**:
  - VPC設計（Public/Private Subnet分離）
  - セキュリティグループによるIPホワイトリスト制御のクラウド移行
  - 内部MariaDBからAWS RDS (PostgreSQL/MySQL) へのデータ移行
- [ ] **Secret管理**: SSH認証鍵およびDB接続パスワードのAWS Secrets Manager / 環境変数化
