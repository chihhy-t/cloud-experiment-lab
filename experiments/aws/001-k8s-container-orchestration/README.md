# AWS EKS コンテナオーケストレーション実験

## 実験概要

Amazon EKS (Elastic Kubernetes Service) を使用したコンテナオーケストレーション環境の構築と運用を実験します。Kubernetesクラスターを基盤として、スケーラブルなマイクロサービスアーキテクチャの構築パターンを検証します。

## 実験目標

### 技術的目標
- Amazon EKSクラスターの構築と設定
- Kubernetesマニフェストによるアプリケーションデプロイ
- Auto Scaling とLoad Balancingの実装
- 監視・ログ収集の仕組み構築
- CI/CDパイプラインとの統合

### 学習目標
- Kubernetesの基本概念とベストプラクティスの習得
- EKSの特性とAWSサービスとの統合理解
- コンテナオーケストレーションの運用ノウハウ蓄積
- Infrastructure as Codeによるクラスター管理

## 実験スコープ

### 対象範囲
- EKSクラスターの構築（Terraform）
- サンプルアプリケーションのデプロイ
- 水平スケーリングの動作確認
- ロードバランサーの設定と動作確認
- 基本的な監視設定

### 対象外
- 本格的なプロダクション運用設定
- 高度なセキュリティ設定
- マルチリージョン構成
- 大規模クラスター管理

## 実験アーキテクチャ

```
Internet
    |
Application Load Balancer
    |
EKS Cluster
├── Node Group (Auto Scaling)
├── Sample Applications (Pods)
├── Services & Ingress
└── Monitoring & Logging
```

## 成功指標

- [ ] EKSクラスターが正常に起動する
- [ ] サンプルアプリケーションがデプロイできる
- [ ] 外部からアプリケーションにアクセスできる
- [ ] Auto Scalingが適切に動作する
- [ ] 基本的な監視データが取得できる

## 実験結果

### 得られた知見
*実験完了後に記録*

### 課題と改善点
*実験完了後に記録*

### 次の実験への示唆
*実験完了後に記録*

## 関連ファイル

- `design/architecture.md`: 詳細なアーキテクチャ設計
- `design/design-doc.md`: 設計ドキュメントと技術選択の判断記録
- `terraform/`: インフラストラクチャ定義
- `application/`: サンプルアプリケーションとマニフェスト
- `dev-log.md`: 開発作業ログ