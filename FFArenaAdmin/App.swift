import SwiftUI

@main
struct FFArenaAdminApp: App { var body: some Scene { WindowGroup { AdminRootView() } } }

struct AdminRootView: View {
    @State private var user = ""
    @State private var pass = ""
    @State private var logged = false
    var body: some View {
        if logged { AdminDashboardView() } else {
            VStack(spacing:16) {
                Text("FF Arena Admin").font(.largeTitle).bold()
                TextField("Usuário", text: $user).textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Senha", text: $pass).textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Entrar") { logged = true }.buttonStyle(.borderedProminent)
                Text("Painel para criar salas e controlar resultados.").font(.footnote)
            }.padding()
        }
    }
}

struct AdminDashboardView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Resumo") { Text("Jogadores online: 38"); Text("Salas abertas: 7"); Text("Resultados pendentes: 3") }
                Section("Controle") {
                    NavigationLink("Criar sala") { CriarSalaView() }
                    NavigationLink("Gerenciar salas") { GerenciarSalasView() }
                    NavigationLink("Validar resultados") { Text("Resultado pendente: X1 #01") }
                    NavigationLink("Gerar Keys") { GerarKeyView() }
                }
            }.navigationTitle("Admin")
        }
    }
}

struct CriarSalaView: View {
    @State private var nome = "X1 #01"
    @State private var entrada = "10"
    @State private var max = "2"
    var body: some View {
        Form {
            TextField("Nome da sala", text: $nome)
            TextField("Entrada em créditos", text: $entrada)
            TextField("Máximo jogadores", text: $max)
            Button("Criar sala") { }
        }.navigationTitle("Criar sala")
    }
}

struct GerenciarSalasView: View {
    @State private var roomID = "123456"
    @State private var senha = "9876"
    var body: some View {
        Form {
            Section("X1 #01") { Text("Jogadores: 2/2"); TextField("ID Free Fire", text: $roomID); TextField("Senha", text: $senha) }
            Button("Enviar ID/Senha") { }
            Button("Confirmar vencedor") { }
            Button("Cancelar sala") { }
        }.navigationTitle("Gerenciar")
    }
}

struct GerarKeyView: View {
    var body: some View {
        VStack(spacing:16) { Text("Key criada:"); Text("FF-8A92-KD72-XP11").font(.title3).bold(); Button("Gerar nova Key"){} }.padding().navigationTitle("Keys")
    }
}
