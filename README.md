# 🛡️ Stress Lab

Java Servlet/JSPをベースにした**ネットワークセキュリティテスト・管理Webアプリケーション**です。

Webブラウザからネットワークポートスキャン、ネットワーク負荷テスト、Kali Linuxリモートターミナル、脆弱性情報の照会、会員管理、掲示板などの機能を一つのWebインターフェースから利用できるように実装しました。

> ⚠️ **注意**
>
> 本プロジェクトは、セキュリティ学習および許可されたテスト環境での利用を目的としています。
> ポートスキャン、ネットワーク負荷テスト、リモートコマンド実行機能は、必ず自分が管理しているシステム、または明示的な許可を得たシステムに対してのみ使用してください。

---

## 📌 プロジェクト概要

Stress Labは、JSP/ServletベースのWebアプリケーションとKali Linux環境をSSH/WebSocketで接続し、ネットワークおよびセキュリティテスト機能を提供するプロジェクトです。

### 主な機能

- 🔐 会員登録 / ログイン
- 👤 会員情報の変更
- 🔑 パスワード変更
- 🗑️ 会員退会
- 📢 お知らせ掲示板
- 🔎 お知らせ検索 / ページネーション
- 📝 お知らせの作成 / 編集 / 削除
- 🔍 Nmapによるポートスキャン
- 📊 ネットワーク負荷テスト
- 🖥️ Kali Linuxリモートターミナル
- 🛡️ CVE / 脆弱性情報管理
- 🔌 SSHによるリモートコマンド実行
- ⚡ WebSocketによるリアルタイムターミナル出力

---

## 🖥️ アーキテクチャ

```text
┌───────────────────────────────┐
│          Web Browser          │
│        JSP / JavaScript       │
└───────────────┬───────────────┘
                │ HTTP / WebSocket
                ▼
┌───────────────────────────────┐
│       Apache Tomcat           │
│                               │
│  Controller (Servlet)         │
│          ↓                    │
│       Service                 │
│          ↓                    │
│         DAO                   │
│          ↓                    │
│      JDBC / MariaDB           │
└───────────────┬───────────────┘
                │ SSH
                ▼
┌───────────────────────────────┐
│          Kali Linux           │
│                               │
│  Nmap                         │
│  hping3                       │
│  Shell Command                │
└───────────────────────────────┘
```

---

## 🏗️ プロジェクト構成

```text
stress_lab/
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

## ⚙️ 技術スタック

| カテゴリ | 技術 |
|---|---|
| 言語 | Java |
| Web | JSP / Servlet |
| フロントエンド | HTML / CSS / JavaScript |
| CSS Framework | Tailwind CSS |
| データベース | MariaDB |
| DBアクセス | JDBC |
| Webサーバー | Apache Tomcat |
| リモート接続 | SSH / JSch |
| リアルタイム通信 | WebSocket |
| ネットワークスキャナ | Nmap |
| 負荷テスト | hping3 |
| 開発環境 | Eclipse |
| ビルド | Eclipse Dynamic Web Project |

---

## 🔐 認証機能

会員機能はServlet + DAO + Sessionをベースに実装しました。

### 会員機能

- ID重複チェック
- 会員登録
- ログイン
- Sessionによるログイン状態の管理
- 会員情報の変更
- パスワード変更
- 会員退会

ログイン成功時には`HttpSession`にログインユーザー情報を保存します。

```java
HttpSession session = req.getSession();
session.setAttribute("loginUser", user);
```

---

## 📢 お知らせ掲示板

お知らせ掲示板はJSP + Servlet + DAO構成で実装しました。

### 主な機能

- お知らせ一覧
- 投稿詳細
- 閲覧数の増加
- 投稿作成
- 投稿編集
- 投稿削除
- タイトル検索
- 内容検索
- ページネーション
- ログインユーザーによる投稿権限確認

### 処理構成

```text
notice.jsp
    ↓
notice Servlet
    ↓
NoticeDao
    ↓
MariaDB
```

---

## 🔎 ポートスキャン

Nmapを利用し、許可されたテスト対象のネットワーク情報を確認できるように実装しました。

### テストプロファイル

- Full Scan
- Fast Port Scan
- Full Port Scan
- Service Version Detection
- OS Detection
- Vulnerability Script Scan

### 処理構成

```text
Port Scan JSP
      ↓
stress Servlet
      ↓
PortScanService
      ↓
SSHUtil
      ↓
Kali Linux
      ↓
Nmap
      ↓
Scan Result
```

`PortScanService`はテスト対象とスキャンオプションを受け取り、SSH経由でKali Linux上のNmapを実行します。

---

## 📊 ネットワーク負荷テスト

Kali Linuxの`hping3`を利用したネットワーク負荷テスト機能を実装しました。

### 対応テストタイプ

- SYN
- UDP
- ICMP
- ACK

### 設定項目

- Target
- Destination Port
- Packet Count
- Delay
- Random Source IP

### 処理構成

```text
DDoS JSP
   ↓
JavaScript Fetch
   ↓
stress Servlet
   ↓
DDoSService
   ↓
SSHUtil
   ↓
Kali Linux
   ↓
hping3
```

> ⚠️ 本機能は、自分が管理している環境、または明示的なテスト許可を得た環境でのみ使用してください。

---

## 🖥️ Kali Linuxリモートターミナル

WebSocketを利用して、WebブラウザからKali Linuxのターミナルとリアルタイムに通信できるように実装しました。

```text
Browser
   │
   │ WebSocket
   ▼
Tomcat WebSocket
   │
   │ SSH
   ▼
Kali Linux Shell
```

### 特徴

- WebSocketによるリアルタイム通信
- SSH接続
- コマンド入力
- コマンド実行結果のリアルタイム表示
- ターミナルログの自動スクロール
- 接続状態の表示
- `clear`コマンド対応

---

## 🔌 SSH通信

リモートKali Linuxとの通信にはJSchを使用しています。

```text
Java Application
       ↓
     JSch
       ↓
      SSH
       ↓
Kali Linux
```

`SSHUtil`でSSH SessionおよびShell Channelを管理し、リモートコマンドの実行結果をJavaアプリケーションへ渡します。

---

## 🛡️ 脆弱性情報管理

CVEベースの脆弱性情報をMariaDBに保存し、検索・照会できるように実装しました。

### 保存情報

- CVE ID
- Title
- Description
- Severity
- CVSS Score
- Vendor
- Product
- Published Date
- Reference URL

```text
VulnerabilityDto
        ↓
VulnerabilityDao
        ↓
MariaDB
```

DAOでは、最近登録された脆弱性や全脆弱性情報などを取得できるようにしています。

---

## 🗄️ データベース

MariaDBを使用し、JDBCを通じてデータベースへアクセスします。

### Member

```text
id
name
password
email
created_at
```

### Notice

```text
notice_id
writer_id
title
content
view_count
created_at
updated_at
```

### Vulnerability

```text
id
cve_id
title
description
severity
cvss_score
vendor
product
published_date
reference_url
created_at
```

---

## 🔄 MVC / DAO構成

本プロジェクトでは、従来型のJSP/Servletアーキテクチャをベースに実装しています。

```text
JSP
 │
 ▼
Servlet Controller
 │
 ▼
Service
 │
 ▼
DAO
 │
 ▼
JDBC
 │
 ▼
MariaDB
```

### Controller

HTTPリクエストを処理し、必要なServiceまたはDAOを呼び出します。

```text
member.java
notice.java
stress.java
```

### Service

ビジネスロジックおよび外部システムとの連携を担当します。

```text
PortScanService
DDoSService
```

### DAO

SQLを実行し、データベースとのデータのやり取りを担当します。

```text
MemberDao
NoticeDao
VulnerabilityDao
```

### DTO

各レイヤー間でデータを受け渡すために使用します。

```text
MemberDto
NoticeDto
VulnerabilityDto
```

---

## 🚀 実行環境

### Requirements

- JDK
- Apache Tomcat
- MariaDB
- EclipseまたはJava Web開発環境
- Kali Linux
- SSH接続環境
- Nmap
- hping3

### 基本的な実行手順

```text
1. MariaDBを起動
2. プロジェクト用DBおよびテーブルを作成
3. MariaDB接続情報を設定
4. Kali LinuxのSSH環境を設定
5. Kali Linuxに必要なテストツールをインストール
6. Tomcatへプロジェクトをデプロイ
7. Webブラウザからアプリケーションへアクセス
```

---

## ⚠️ セキュリティに関する注意事項

本プロジェクトにはリモートコマンド実行機能が含まれているため、実際の運用環境では追加のセキュリティ対策が必要です。

特に以下の対策を想定しています。

- SSHアカウント情報をソースコードにハードコーディングしない
- 環境変数またはSecret Managerを使用する
- 管理者認証および権限管理
- コマンド入力値のバリデーション
- Allowlistによる実行可能コマンド・オプションの制限
- Target IP / Networkの検証
- CSRF対策
- Sessionセキュリティ設定
- パスワードのハッシュ化
- SSH Key認証
- 操作ログ・監査ログの記録
- テスト対象に対するアクセス権限の確認

---

## 📚 学習目的

本プロジェクトでは、以下の技術を学習・実装しました。

- Java Servlet / JSP
- MVCアーキテクチャ
- DAO / DTOパターン
- JDBC
- MariaDB
- Session Authentication
- WebSocket
- SSHリモート通信
- JSch
- Nmap
- ネットワークセキュリティテスト
- CVE / 脆弱性情報管理
- Webベースのセキュリティテストツール設計

---

## 📝 プロジェクト進捗

### Completed

- [x] 会員登録 / ログイン
- [x] 会員情報管理
- [x] お知らせCRUD
- [x] お知らせ検索 / ページネーション
- [x] 脆弱性情報管理
- [x] Nmapポートスキャン
- [x] SSHによるKali Linux連携
- [x] WebSocketターミナル
- [x] ネットワーク負荷テストUI

### Future Improvements

- [ ] パスワードのハッシュ化
- [ ] 管理者権限の分離
- [ ] コマンドAllowlist
- [ ] CSRF対策
- [ ] 入力値バリデーションの強化
- [ ] テスト実行履歴の管理
- [ ] テスト結果の可視化
- [ ] Dockerベースの実行環境
- [ ] 環境変数によるSecret管理
- [ ] Spring Bootベースのアーキテクチャへの移行

---

## 👨‍💻 Project

**Stress Lab**

Java Servlet/JSPをベースとしたネットワークセキュリティテスト・管理Webアプリケーション。

> 教育および許可されたセキュリティテスト環境での利用を目的としたプロジェクトです。
