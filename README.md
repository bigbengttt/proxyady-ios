# BattleIsland2018 Direct Build Fixed

Esse ZIP corrige a falha do GitHub Actions usando build direto com clang.
Não depende de xcodebuild nem de scheme.

Tem:
- Sources/main.m
- Info.plist
- .github/workflows/build-unsigned-ipa.yml
- BattleIsland2018.xcodeproj para o bot reconhecer

O Actions gera:
BattleIsland2018-unsigned-ipa
