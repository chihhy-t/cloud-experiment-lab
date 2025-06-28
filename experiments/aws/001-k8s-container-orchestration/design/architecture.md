# EKS コンテナオーケストレーション アーキテクチャ設計

## システム概要

Amazon EKS を中核としたコンテナオーケストレーション環境を構築し、スケーラブルなマイクロサービスアプリケーションの実行基盤を提供します。

## アーキテクチャ図

詳細なアーキテクチャ図は以下のdraw.ioファイルで確認できます：

📊 **[EKS アーキテクチャ図](./diagrams/eks-architecture.drawio)**

この図では以下の要素を視覚的に表現しています：
- **ネットワーク構成**: VPC、パブリック/プライベートサブネット
- **EKSクラスター**: Control PlaneとWorker Nodes
- **ロードバランシング**: Application Load Balancer
- **支援サービス**: ECR、CloudWatch、IAM、Route53

> **Note**: draw.ioファイルは [draw.io](https://app.diagrams.net/) または [VS Code Draw.io Extension](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio) で開くことができます。

## コンポーネント詳細

### 1. ネットワーク構成

#### VPC設計
- **CIDR**: 10.0.0.0/16
- **Multi-AZ**: ap-northeast-1a, ap-northeast-1b
- **Public/Private**: 階層化されたサブネット構成

#### サブネット設計
```
Public Subnets (Internet Gateway経由)
├── 10.0.1.0/24 (AZ-a) - ALB配置
└── 10.0.2.0/24 (AZ-b) - ALB配置

Private Subnets (NAT Gateway経由)
├── 10.0.3.0/24 (AZ-a) - EKS Worker Nodes
└── 10.0.4.0/24 (AZ-b) - EKS Worker Nodes
```

### 2. EKS クラスター

#### Control Plane
- **管理方式**: AWS Managed
- **API Server**: Multi-AZ配置による高可用性
- **etcd**: AWS管理によるバックアップ・復旧
- **Kubernetes Version**: 1.28 (最新安定版)

#### Worker Nodes
- **Node Group**: Managed Node Groups使用
- **Instance Type**: t3.medium (実験用)
- **Auto Scaling**: 2-10ノード（CPU使用率ベース）
- **AMI**: Amazon EKS Optimized Linux

### 3. アプリケーション層

#### デプロイ構成
```
Kubernetes Resources
├── Namespace: demo-app
├── Deployment: web-app (3 replicas)
├── Service: LoadBalancer type
├── HPA: Horizontal Pod Autoscaler
└── Ingress: ALB Ingress Controller
```

#### サンプルアプリケーション
- **種類**: Nginx ベースのWebアプリケーション
- **コンテナイメージ**: ECRにプッシュ
- **レプリカ数**: 3（初期設定）
- **リソース制限**: CPU 100m, Memory 128Mi

### 4. ロードバランシング

#### Application Load Balancer
- **配置**: Public サブネット
- **SSL/TLS**: 実験範囲外（HTTP のみ）
- **Health Check**: /health エンドポイント
- **Target**: EKS NodePort Service

#### Ingress Controller
- **種類**: AWS Load Balancer Controller
- **機能**: ALBの自動プロビジョニング
- **Annotations**: AWS固有の設定

### 5. 監視・ログ

#### CloudWatch統合
- **Container Insights**: クラスターメトリクス
- **Logs**: アプリケーション・システムログ
- **Alarms**: リソース使用率ベース

#### メトリクス収集
```
Cluster Level
├── Node CPU/Memory 使用率
├── Pod数とリソース使用量
└── ネットワーク I/O

Application Level
├── レスポンス時間
├── エラー率
└── スループット
```

## スケーリング戦略

### 1. Cluster Autoscaler
- **対象**: Worker Node数の調整
- **トリガー**: Pod配置不可時の自動スケールアウト
- **制限**: 最小2ノード、最大10ノード

### 2. Horizontal Pod Autoscaler (HPA)
- **対象**: アプリケーションPod数の調整
- **メトリクス**: CPU使用率（70%閾値）
- **範囲**: 2-20 replica

### 3. Vertical Pod Autoscaler (VPA)
- **実験範囲外**: 今回は未実装
- **将来拡張**: リソース要求の自動調整

## セキュリティ設計

### 1. IAM統合
```
Roles & Policies
├── EKS Cluster Service Role
├── EKS Node Group Instance Role
├── ALB Ingress Controller Role
└── CloudWatch Agent Role
```

### 2. Pod Security
- **Security Context**: 非root実行
- **Network Policies**: 実験範囲外
- **RBAC**: 基本的な権限分離

### 3. Secrets Management
- **Kubernetes Secrets**: 設定情報
- **AWS Secrets Manager**: 実験範囲外

## デプロイメント戦略

### 1. Infrastructure as Code
- **Terraform**: EKSクラスター、VPC、IAM
- **Kubernetes Manifests**: アプリケーションデプロイ

### 2. CI/CDパイプライン
- **実験範囲**: 手動デプロイメント
- **将来拡張**: GitHub Actions統合

### 3. Blue/Green Deploy
- **実験範囲外**: Rolling Update のみ
- **将来実験**: Argo Rollouts導入

## コスト最適化

### 1. リソース設計
- **Node Type**: t3.medium（実験用途）
- **Spot Instances**: 実験範囲外
- **Auto Scaling**: 未使用時の自動縮小

### 2. 監視ポイント
- **EC2コスト**: ノード数×稼働時間
- **EKSコスト**: $0.10/hour per cluster
- **ALBコスト**: $0.025/hour + データ転送

## リスクと制約

### 1. 技術的制約
- **Single Region**: マルチリージョン未対応
- **Backup**: 自動バックアップ未設定
- **Disaster Recovery**: 実験範囲外

### 2. 運用制約
- **監視**: 基本メトリクスのみ
- **アラート**: CPU/Memory閾値のみ
- **ログ保持**: CloudWatch標準設定

### 3. セキュリティ制約
- **TLS**: 実験範囲外
- **Network Policies**: 実装なし
- **Vulnerability Scanning**: 実験範囲外