# App de Controle de Manutenção Veicular (Carro e Moto)

MVP em Flutter/GetX com foco no diferencial: cálculo de vencimento de manutenção
por **data**, por **km rodado**, ou pelos dois (o que vencer primeiro).

## Estrutura

```
lib/
  core/
    calculations/maintenance_calculator.dart   <- lógica pura do diferencial (data/km)
    services/auth_service.dart                 <- login Firebase
    services/purchase_service.dart             <- RevenueCat + entitlement premium
  data/local/
    tables.dart                                <- schema drift
    app_database.dart                          <- queries
  modules/
    auth/          -> tela de login
    home/           -> lista de veículos com status
    add_vehicle/    -> cadastro de veículo (carro/moto)
    vehicle_detail/ -> abas de lembretes e histórico
    add_event/      -> registrar manutenção feita
    add_reminder/   -> configurar lembrete (data e/ou km)
    paywall/        -> tela de Premium
  widgets/
    vehicle_card.dart, status_badge.dart, ad_banner_widget.dart
test/
  maintenance_calculator_test.dart             <- testes da lógica de cálculo
```

## Passos antes de rodar

1. **Instalar dependências**
   ```
   flutter pub get
   ```

2. **Gerar código do drift** (banco local) — precisa rodar toda vez que mexer em `tables.dart`:
   ```
   dart run build_runner build --delete-conflicting-outputs
   ```
   Isso gera `lib/data/local/app_database.g.dart`, que ainda não existe neste projeto.

3. **Firebase**
   - Criar projeto no [console do Firebase](https://console.firebase.google.com).
   - Ativar **Authentication > Google** e (opcional) **Anônimo**.
   - Instalar a FlutterFire CLI e rodar:
     ```
     dart pub global activate flutterfire_cli
     flutterfire configure
     ```
   - Isso substitui o `lib/firebase_options.dart` (hoje é só um placeholder) pelo arquivo real.

4. **RevenueCat**
   - Criar conta em [revenuecat.com](https://www.revenuecat.com).
   - Conectar o app Android (usa o mesmo `applicationId` do `android/app/build.gradle`).
   - Criar o produto de assinatura no **Google Play Console** primeiro (Monetização > Assinaturas), depois vincular no RevenueCat.
   - Criar um **entitlement** chamado `premium` (tem que bater com `kPremiumEntitlementId` em `purchase_service.dart`).
   - Copiar a **chave pública Android** e colar em `main.dart`, no lugar de `'SUA_CHAVE_PUBLICA_ANDROID_REVENUECAT'`.

5. **AdMob**
   - Criar app no [AdMob](https://admob.google.com), pegar o App ID.
   - Colocar o App ID no `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <meta-data
         android:name="com.google.android.gms.ads.APPLICATION_ID"
         android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
     ```
   - Trocar o `_testAdUnitId` em `ad_banner_widget.dart` pelo ID real do bloco de anúncio quando for publicar (o ID de teste é seguro pra usar durante o desenvolvimento).

6. **Rodar os testes** (a lógica principal já está coberta):
   ```
   flutter test
   ```

## O que ainda falta pro MVP completo (próximos passos sugeridos)

- Agendamento de notificação local (`flutter_local_notifications`) a partir do
  `effectiveDueDate` calculado — hoje o cálculo já entrega a data certa,
  falta só disparar o agendamento quando um lembrete é criado/atualizado.
- Tela de edição/exclusão de veículo e de lembrete.
- OCR de documento (`google_ml_kit`) — recurso Premium mencionado no paywall,
  ainda não implementado.
- Anexo de foto de nota fiscal no evento (`image_picker` já está no `pubspec.yaml`,
  falta a UI de captura/seleção).
- Relatório de gastos por veículo (quanto você gastou de manutenção no ano — dado que gera "aha moment" forte)
- Regras do Android para permitir emitir notificação em background em
  fabricantes que matam processo agressivamente (Xiaomi, Samsung) — vale
  testar cedo, é fricção comum nesse tipo de app.



  Diferencial real que nenhum concorrente pequeno costuma ter bem feito: usuário tira foto do CRLV, do boleto do IPVA, ou da apólice de seguro, e o app tenta extrair data de vencimento automaticamente via OCR (google_ml_kit tem text recognition on-device, funciona offline, sem custo de API por requisição). Isso reduz fricção de cadastro drasticamente — em vez de digitar tudo, tira foto e confirma. Vale colocar isso como funcionalidade Premium de destaque, é o tipo de coisa que vira print de review 5 estrelas.
# autodia
