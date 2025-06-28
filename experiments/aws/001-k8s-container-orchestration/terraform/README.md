# EKS Container Orchestration - Terraform Infrastructure

設計書の要件に基づき、EKSクラスターとその関連リソースをTerraformで管理するためのコード群です。

## 📁 ディレクトリ構成

```
terraform/
├── Makefile                    # プロビジョニング用のMakefile
├── environments/
│   └── dev/                    # 開発環境設定
│       ├── main.tf             # メインの構成
│       ├── variables.tf        # 変数定義
│       ├── outputs.tf          # 出力値
│       ├── terraform.tfvars    # パラメータ設定
│       └── versions.tf         # プロバイダー制約
├── modules/
│   ├── vpc/                    # VPC・ネットワーク
│   ├── eks/                    # EKSクラスター
│   ├── node-groups/           # Managed Node Groups
│   └── monitoring/            # CloudWatch Container Insights
└── shared/
    ├── data.tf                # 共通データソース
    └── locals.tf              # 共通ローカル値
```

## 🏗️ アーキテクチャ

### 主要コンポーネント

1. **VPC モジュール**
   - パブリック/プライベートサブネット（2AZ）
   - Internet Gateway、NAT Gateway
   - Security Group設定

2. **EKS モジュール**
   - Kubernetes 1.28 Control Plane
   - IAM Role設定（最小権限）
   - CloudWatch ログ統合

3. **Node Groups モジュール**
   - t3.small Managed Node Groups
   - Auto Scaling設定（1-3ノード）
   - セキュリティグループ設定

4. **Monitoring モジュール**
   - CloudWatch Container Insights
   - ログ保持期間設定（7日）

## 🚀 使用方法

### 前提条件

1. **AWS CLI設定**
   ```bash
   aws configure
   ```

2. **Terraform インストール**
   ```bash
   # macOS
   brew install terraform
   
   # 他のOSは公式サイト参照
   ```

### 基本的な使用方法

1. **利用可能なコマンド確認**
   ```bash
   make help
   ```

2. **設定確認・編集**
   ```bash
   vi environments/dev/terraform.tfvars  # 必要に応じて編集
   ```


### 段階的デプロイ

1. **設定検証**
   ```bash
   make validate  # Terraform設定の検証とフォーマット
   ```

2. **デプロイ計画確認**
   ```bash
   make plan      # 作成されるリソースの確認
   ```

3. **EKSクラスター適用**
   ```bash
   make apply     # 実際の変更適用
   ```



### その他の便利なコマンド

```bash
# 前提条件チェック
make check-prereqs

# 現在の状況確認
make status

# Terraform出力値表示
make outputs

# ファイルフォーマット
make fmt

# キャッシュクリア
make clean

# クラスター削除（要注意！）
make destroy
```

## ⚙️ パラメータ設定

### terraform.tfvars での主要設定

```hcl
# 基本設定
environment = "dev"
region      = "ap-northeast-1"

# クラスター設定
cluster_name       = "k8s-experiment-dev"
kubernetes_version = "1.28"

# ネットワーク設定
vpc_cidr = "10.0.0.0/16"

# ノード設定（設計書要件: t3.small）
instance_types = ["t3.small"]
desired_size   = 2
max_size       = 3
min_size       = 1
```

## 💰 コスト見積もり

設計書の構成での月額概算：

| リソース | 数量 | 月額概算 |
|----------|------|----------|
| EKS Cluster | 1 | $73 |
| t3.small nodes | 2 | $30 |
| NAT Gateway | 2 | $90 |
| その他 | - | $10 |
| **合計** | - | **約$200** |

## 🔒 セキュリティ

### 実装済み

- ✅ IAM Role最小権限
- ✅ プライベートサブネット配置
- ✅ Security Group制限
- ✅ CloudWatch ログ有効化

### 実験用で省略

- ❌ TLS/SSL設定
- ❌ Network Policies
- ❌ Pod Security Standards

## 🚨 注意事項

1. **実験用構成**: プロダクション利用不可
2. **コスト**: NAT Gatewayで約$90/月の固定費
3. **セキュリティ**: 最小限の設定のみ
4. **ローカル状態**: terraform stateはローカル管理

## 🔄 次のステップ

1. **GitHub Actions でのアプリケーションデプロイ**
   - Terraform完了後、GitHub Actionsでkubectl操作を実行
   - CI/CDパイプラインでアプリケーションをデプロイ

2. **監視確認**
   - AWS Console > CloudWatch > Container Insights
   - メトリクス・ログ確認
   ```bash
   make status    # インフラ状況確認
   make outputs   # 接続情報取得
   ```

3. **環境別適用**
   ```bash
   # 本番環境への適用例
   ENVIRONMENT=prod make apply
   ```

## 🐛 トラブルシューティング

### よくある問題

1. **前提条件エラー**
   ```bash
   make check-prereqs  # 前提条件チェック
   ```

2. **権限エラー**
   ```bash
   aws sts get-caller-identity  # AWS認証確認
   ```

3. **リソース制限**
   ```bash
   aws service-quotas get-service-quota --service-code eks --quota-code L-1194D53C
   ```

4. **デプロイ状況確認**
   ```bash
   make status    # 現在の状況確認
   make outputs   # Terraform出力値確認
   ```

### Makeコマンド一覧

すべての利用可能なコマンドを確認：
```bash
make help
```

### 環境変数

```bash
# デフォルト値の変更例
ENVIRONMENT=prod REGION=us-west-2 make apply
```