# K8s Container Orchestration - Application

シンプルなnginxベースのアプリケーションで、Kubernetesのコンテナオーケストレーション機能をテストします。

## アーキテクチャ

### フロントエンド
- **技術**: Nginx + 静的ファイル (HTML/CSS/JavaScript)
- **機能**: 
  - ダッシュボードUI
  - バックエンドAPIとの通信
  - システム状態表示
  - APIテスト機能

### バックエンド
- **技術**: Nginx (APIシミュレーション)
- **機能**:
  - RESTful API エンドポイント
  - JSONレスポンス
  - ヘルスチェック
  - メトリクス提供

## API エンドポイント

### バックエンド API
- `GET /health` - ヘルスチェック
- `GET /users` - ユーザー一覧
- `GET /users/{id}` - 特定ユーザー情報
- `GET /metrics` - システムメトリクス
- `GET /info` - API情報
- `GET /version` - バージョン情報

### フロントエンド
- `GET /health` - フロントエンドヘルスチェック
- `GET /` - メインダッシュボード
- `/api/*` - バックエンドAPIへのプロキシ

## ローカル開発

### 必要なツール
- Docker & Docker Compose
- Make
- curl & jq (テスト用)

### 起動手順

```bash
# アプリケーションをビルドして起動
make local-up

# 動作確認
make local-test

# 停止
make local-down
```

### アクセス URL
- フロントエンド: http://localhost:8080
- バックエンド: http://localhost:8081

## Kubernetes デプロイ

### 前提条件
- Kubernetesクラスターへのアクセス
- kubectl設定済み
- AWS Load Balancer Controller (Ingress用)

### デプロイ手順

```bash
# ビルドしてKubernetesにデプロイ
make deploy

# デプロイ状況確認
make k8s-status

# ログ確認
make k8s-logs

# テスト実行
make k8s-test
```

### リソース構成
- **Namespace**: `k8s-experiment`
- **Frontend**: 3レプリカ、HPA有効
- **Backend**: 2レプリカ、HPA有効
- **Ingress**: ALB経由で外部公開
- **Services**: ClusterIP型で内部通信

## ECR プッシュ

```bash
# AWS ECRにイメージをプッシュ
make push-ecr ECR_REPOSITORY_PREFIX=123456789012.dkr.ecr.ap-northeast-1.amazonaws.com
```

## テスト項目

### 基本機能テスト
- [ ] フロントエンド表示
- [ ] バックエンドAPI応答
- [ ] フロントエンド→バックエンド通信
- [ ] ヘルスチェック動作

### Kubernetesテスト
- [ ] Pod起動とReady状態
- [ ] Service経由のアクセス
- [ ] Ingress経由の外部アクセス
- [ ] HPA動作確認
- [ ] ローリングアップデート

### 負荷テスト
- [ ] CPU使用率上昇時のスケーリング
- [ ] メモリ使用率上昇時のスケーリング
- [ ] 負荷軽減時のスケールダウン

## ディレクトリ構成

```
application/
├── frontend/
│   ├── src/
│   │   ├── index.html
│   │   ├── style.css
│   │   └── app.js
│   ├── nginx/
│   │   └── nginx.conf
│   └── Dockerfile
├── backend/
│   ├── nginx/
│   │   └── nginx.conf
│   └── Dockerfile
├── k8s/
│   ├── namespace.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── ingress.yaml
│   └── hpa.yaml
├── docker-compose.yaml
├── Makefile
└── README.md
```

## Make コマンド

| コマンド | 説明 |
|---------|------|
| `make help` | 使用可能なコマンド一覧 |
| `make build` | Dockerイメージをビルド |
| `make local-up` | ローカル環境で起動 |
| `make local-test` | ローカル環境をテスト |
| `make deploy` | Kubernetesにデプロイ |
| `make k8s-status` | K8sリソース状況確認 |
| `make test` | 自動判別でテスト実行 |
| `make clean` | 環境クリーンアップ |