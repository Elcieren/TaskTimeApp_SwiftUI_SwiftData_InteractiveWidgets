## TaskTimeApp_SwiftUI_SwiftData_InteractiveWidgets
| Uygulama İci Kullanım | Kaydetme && Silme && Düzenleme|
|---------|---------|
| ![Video 1](https://github.com/user-attachments/assets/3a8ccbbb-cff3-44cb-9289-e946d367f7f3) | ![Video 2](https://github.com/user-attachments/assets/0b5414a5-edae-4965-a1f3-6537f84b8190) | 


 <details>
    <summary><h2>Uygulamanın Amacı </h2></summary>
    Proje Amacı
   TaskTime uygulaması, kullanıcıların günlük görevlerini düzenlemelerine ve bu görevler için belirli bir saat ve dakika seçmelerine olanak tanıyan bir görev takip aracıdır. Uygulamanın başlıca özellikleri:
   Görev Ekleme: Kullanıcılar, bir görev adı ve zaman belirterek yeni görevler ekleyebilir.
   Görev Listeleme: Ana ekranda kullanıcıya tüm görevler saat ve dakika bilgileriyle birlikte listelenir.
   Görev Güncelleme: Eklenen görevler düzenlenebilir. Zaman, görev adı veya tamamlanma durumu değiştirilebilir.
   Görev Silme: Kullanıcı, listeden gereksiz gördüğü görevleri kaldırabilir.
   Tamamlanma Durumu: Görevlerin tamamlanıp tamamlanmadığını işaretleyerek kullanıcı organize bir şekilde görevlerini takip edebilir
  </details>  



  <details>
    <summary><h2>MVVM Kullanımı</h2></summary>
    TaskTime uygulaması, Model-View-ViewModel (MVVM) tasarım desenini kullanarak geliştirilmiştir. Bu yaklaşım, SwiftUI'nin reaktif yapısıyla uyumlu bir şekilde çalışarak kodun daha okunabilir, test edilebilir ve sürdürülebilir olmasını sağlar:
    Model:
    Uygulamanın veri yapısıdır. Bu projede, TaskTime modeli görev adı, saat, dakika ve tamamlanma durumu gibi bilgileri içerir. Ayrıca, bu model SwiftData kullanılarak cihazda kalıcı olarak saklanır.
    View:
    Kullanıcı arayüzünden sorumludur. addTaskScreen, ListScreen ve TaskTimeDetailScreen gibi ekranlar, kullanıcıya veri girişini ve görüntülemesini sağlar. View, yalnızca ViewModel'den gelen veriyi gösterir.
    ViewModel:
    İş mantığını ve veri işleme süreçlerini yönetir. Bu proje SwiftData'nın otomatik veri yönetimi özelliklerini kullandığı için ViewModel katmanı minimal tutulmuş, veri yönetimi büyük ölçüde SwiftData’ya bırakılmıştır. Ancak, TaskListView gibi bileşenler veri sorgulama ve filtreleme işlemlerini içerir.
    MVVM kullanımı, arayüzün yeniden kullanılabilir bileşenler olarak oluşturulmasını ve iş mantığının kullanıcı arayüzünden ayrılmasını sağlar. Bu da hem test edilebilirlik hem de uzun vadede kolay bakım sağlar
    
  </details> 
  
  <details>
    <summary><h2>SwiftData Kullanımı</h2></summary>
    SwiftData, Apple’ın CoreData’dan daha sade ve modern bir veri yönetim çerçevesi olarak tanıtılmıştır. Bu projede SwiftData, görevlerin cihazda kalıcı olarak saklanmasını sağlamak için kullanılmıştır:
    Model Annotation (@Model):
    @Model kullanılarak TaskTime sınıfı otomatik olarak veri tabanı tarafından tanınır ve SwiftData ile ilişkilendirilir.
    Veri Kaydetme:
    Kullanıcı yeni bir görev eklediğinde context.insert() kullanılarak model veritabanına eklenir.
    Veri Güncelleme:
    Görev güncelleme işlemleri doğrudan model üzerinde gerçekleştirilir ve ardından context.save() çağrısıyla değişiklikler kaydedilir.
    Veri Silme:
    context.delete() ile seçilen görev veritabanından kaldırılır.
    SwiftData'nın basit ve deklaratif yapısı, veri yönetimi işlemlerini hem geliştirici hem de performans açısından daha verimli hale getirir. Bu proje, SwiftData'nın sunduğu bu avantajlardan faydalanarak cihazda hızlı ve güvenilir veri yönetimi sağlamaktadır
    
  </details> 


  <details>
    <summary><h2>Model: TaskTime</h2></summary>
    Amaç: TaskTime, bir görev ve saat bilgilerini içeren bir veri modelidir.
    SwiftData Kullanımı: @Model ile işaretlenerek SwiftData ile kalıcı veri yönetimi sağlanmıştır.
    Özellikler:
    id: Her göreve özel benzersiz bir kimlik (UUID).
    task: Görev adı.
    saat ve dakika: Görevin saati ve dakikası.
    isDone: Görevin tamamlanma durumu
    
    ```
    import Foundation
    import SwiftData

    @Model
    final class TaskTime: Identifiable {
    var id: String = UUID().uuidString
    var task: String
    var saat: Int
    var dakika: Int
    var isDone: Bool = false
    
    init(task: String, saat: Int, dakika: Int, isDone: Bool) {
        self.task = task
        self.saat = saat
        self.dakika = dakika
        self.isDone = isDone
    }
    }




    ```
  </details> 


  <details>
    <summary><h2>Ekleme Ekranı: addTaskScreen</h2></summary>
    Amaç: Kullanıcıdan görev adı, saat ve dakika bilgilerini alarak yeni bir TaskTime kaydı oluşturur.
    Form Validasyonu: Görev adı boş bırakıldığında "Kaydet" butonu devre dışı kalır.
    SwiftData Entegrasyonu: context.insert() ve context.save() kullanılarak veri yerel olarak saklanır.
    Saat ve Dakika Seçimi: Tekerlek stili Picker kullanılmıştır.
    
    ```
    struct addTaskScreen: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var task: String = ""
    @State private var selectedSaat: Int = 0
    @State private var selectedDakika: Int = 0
    
    let saat = Array(0...23)
    let dakika = Array(0...59)
    
    private var isFormValid: Bool {
        !task.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField(text: $task) {
                    Text("Task")
                }
                VStack {
                    Text("Seçilen Zaman: \(formattedTime)")
                        .font(.headline)
                        .padding()
                    
                    HStack {
                        Picker("Saat", selection: $selectedSaat) {
                            ForEach(saat, id: \.self) { hour in
                                Text("\(hour) saat").tag(hour)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 150)
                        .clipped()
                        
                        Text(":")
                            .font(.largeTitle)
                        
                        Picker("Dakika", selection: $selectedDakika) {
                            ForEach(dakika, id: \.self) { minute in
                                Text("\(minute) dakika").tag(minute)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 125, height: 150)
                        .clipped()
                    }
                    .padding()
                }
            }
            .navigationTitle("TaskTime")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Geri Dön") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kaydet") {
                        let taskTime = TaskTime(task: task, saat: selectedSaat, dakika: selectedDakika, isDone: false)
                        context.insert(taskTime)
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    var formattedTime: String {
        String(format: "%02d:%02d", selectedSaat, selectedDakika)
    }
    }


    ```
  </details> 


  <details>
    <summary><h2>Görev Listesi: ListScreen</h2></summary>
    Amaç: Kullanıcının mevcut görevlerini görüntüleyebileceği bir liste ekranıdır.
    Veri Sorgulama: @Query ile TaskTime verileri alınır ve göreve göre sıralanır.
    Ekleme: "Ekle" butonuyla addTaskScreen ekranı açılır.
    
    ```
    struct ListScreen: View {
    @Query(sort: \TaskTime.task, order: .forward) private var taskTime: [TaskTime]
    @State private var isAddTaskTimePresented: Bool = false
    
    var body: some View {
        TaskListView(taskTimes: taskTime)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Ekle") {
                        isAddTaskTimePresented = true
                    }
                }
            }
            .sheet(isPresented: $isAddTaskTimePresented) {
                NavigationStack {
                    addTaskScreen()
                }
            }
    }
   }






    ```
  </details> 

  

  
  <details>
    <summary><h2>Görev Detayı: TaskTimeDetailScreen</h2></summary>
     Amaç: Görev detaylarını düzenlemek ve güncellemek için kullanılır.
     Veri Güncelleme: taskTime üzerindeki değişiklikler context.save() ile kaydedilir.
     Durum Güncelleme: Kullanıcı görevi "Yapıldı" veya "Yapılmadı" olarak işaretleyebilir.
    
    ```
    struct TaskTimeDetailScreen: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var task: String = ""
    @State private var selectedSaat: Int = 0
    @State private var selectedDakika: Int = 0
    @State var completionStatus: Bool = false
    
    let taskTime: TaskTime
    
    var body: some View {
        Form {
            TextField(text: $task) {
                Text("Task")
            }
            VStack {
                Text("Seçilen Zaman: \(formattedTime)")
                    .font(.headline)
                    .padding()
                
                HStack {
                    Picker("Saat", selection: $selectedSaat) {
                        ForEach(Array(0...23), id: \.self) { Text("\($0) saat").tag($0) }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100, height: 150)
                    .clipped()
                    
                    Text(":").font(.largeTitle)
                    
                    Picker("Dakika", selection: $selectedDakika) {
                        ForEach(Array(0...59), id: \.self) { Text("\($0) dakika").tag($0) }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 125, height: 150)
                    .clipped()
                }
                .padding()
                
                Picker("Görev Durumu", selection: $completionStatus) {
                    Text("Yapılmadı").tag(false)
                    Text("Yapıldı").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button("Güncelle") {
                    taskTime.task = task
                    taskTime.saat = selectedSaat
                    taskTime.dakika = selectedDakika
                    taskTime.isDone = completionStatus
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    dismiss()
                }
                .font(.title2)
                .padding()
            }
            .onAppear {
                task = taskTime.task
                selectedSaat = taskTime.saat
                selectedDakika = taskTime.dakika
                completionStatus = taskTime.isDone
            }
        }
    }
    
    var formattedTime: String {
        String(format: "%02d:%02d", selectedSaat, selectedDakika)
    }
    }



    ```
  </details> 


  <details>
    <summary><h2>Liste Görünümü: TaskListView</h2></summary>
     Amaç: Görev listesini görüntüler ve kullanıcıya görev detaylarına gitme veya silme imkanı tanır.
     Silme İşlemi: context.delete() ile veri silinir ve ardından kaydedilir.
    
    ```
    struct TaskListView: View {
    let taskTimes: [TaskTime]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        List {
            ForEach(taskTimes) { taskTime in
                NavigationLink(value: taskTime) {
                    HStack {
                        Text(taskTime.task)
                            .strikethrough(taskTime.isDone, color: .red)
                            .font(.title3)
                        Spacer()
                        Text("\(taskTime.saat):\(taskTime.dakika)")
                    }
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    let selectedTask = taskTimes[index]
                    context.delete(selectedTask)
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .navigationDestination(for: TaskTime.self) { taskTime in
            TaskTimeDetailScreen(taskTime: taskTime)
        }
    }
    }




    ```
  </details>

<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Ana Ekran Task Listeleme</h4>
            <img src="https://github.com/user-attachments/assets/2a31ba7e-52a7-49e8-8ad5-e7b07de54384" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Task Ekleme</h4>
            <img src="https://github.com/user-attachments/assets/4a28ce76-2096-455d-9189-ab02e6070d61" style="width: 100%; height: auto;">
        </td>
      <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Task Duzenleme</h4>
            <img src="https://github.com/user-attachments/assets/713e551f-ce9b-4f0d-8aa8-728959b51077" style="width: 100%; height: auto;">
        </td>
      <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Task Silme</h4>
            <img src="https://github.com/user-attachments/assets/605c55e6-8fe7-4833-93db-1edc99e53b04" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 
