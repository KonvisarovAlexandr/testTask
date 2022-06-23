//
//  InitialViewController.swift
//  RickAndMorty

import UIKit
import CoreData

class InitialViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,Delegate{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var images:[ImageCoreData] = []{
        didSet{
            self.saveData()
        }
    }
    @IBOutlet weak var tableViewContent: UITableView!
    
    var characterers:[Character] = []
    var page = 1
    
    lazy var contentViewController: UIViewController? = {
        let postsViewController = self.storyboard?.instantiateViewController(identifier: "ContentViewController")
        return postsViewController
    }()
    
    var contentVC: ContentViewController? {
        get {
            let vc = contentViewController as? ContentViewController
            vc?.parentVC = self
            vc?.delegate = self
            vc?.modalTransitionStyle = .crossDissolve
            vc?.modalPresentationStyle = .fullScreen
            return vc
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        NetworkManager.shared.getCharacters(url:"https://rickandmortyapi.com/api/character", page: page, completion: { responce in
            self.characterers = responce ?? []
            self.tableViewContent.delegate = self
            self.tableViewContent.dataSource = self
            self.tableViewContent.reloadData()
        })
        // Do any additional setup after loading the view.
        tableViewContent.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: "CharacterTableViewCell")
    }
    
    func fetchData(){
        do{
            let fetchRequest: NSFetchRequest<ImageCoreData> = ImageCoreData.fetchRequest()
            self.images = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveData(){
        do{
            try self.context.save()
        } catch {
            print("saving error")
        }
    }
    
    func addOneImageToCoreData(image:UIImage, id:Int){
        let coreImage = ImageCoreData(context: context)
        coreImage.image = image.convertImageToData()
        coreImage.id = Int16(id)
        self.images.append(coreImage)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentNewCharacter(character: characterers[indexPath.row])
    }
    
    func dissmissAndShowNewCharacter(character: Character) {
        presentNewCharacter(character: character)
    }
    
    func presentNewCharacter(character: Character){
        contentVC?.character = character
        self.present(contentVC!, animated: true, completion: {
            
        })
    }
    
    func checkIfImageIsInCoreDataAndSetIt(whereToSet: inout UIImageView?,characterWhichIdChecking:Character){
        if images.contains(where: {$0.id == Int16(characterWhichIdChecking.id)}){
            whereToSet?.image = UIImage(data: images[images.firstIndex(where: {$0.id == characterWhichIdChecking.id}) ?? 0].image ?? Data())
        } else {
            whereToSet?.loadImageUsingCache(withUrl: characterWhichIdChecking.image){ imageWhichWasGet in
                self.addOneImageToCoreData(image: imageWhichWasGet ?? UIImage() , id: characterWhichIdChecking.id)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell") as! CharacterTableViewCell
        cell.nameLabel.text = self.characterers[indexPath.row].name
        cell.locationName.text = self.characterers[indexPath.row].location.name
        checkIfImageIsInCoreDataAndSetIt(whereToSet: &cell.characterImage, characterWhichIdChecking: characterers[indexPath.row])
//        if images.contains(where: {$0.id == Int16(characterers[indexPath.row].id)}){
//            cell.characterImage.image = UIImage(data: images[images.firstIndex(where: {$0.id == characterers[indexPath.row].id}) ?? 0].image ?? Data())
//        } else {
//            cell.characterImage.loadImageUsingCache(withUrl: self.characterers[indexPath.row].image){_ in
//                self.addOneImageToCoreData(image: cell.characterImage.image ?? UIImage() , id: self.characterers[indexPath.row].id)
//            }
//        }
        NetworkManager.shared.getOneEpizode(url:characterers[indexPath.row].episode.first ?? "", completion: { episodeName in
            cell.episodeName.text = episodeName?.name
        })
        if indexPath.row == characterers.count - 5 {
            self.page = self.page + 1
            NetworkManager.shared.getCharacters(url:"https://rickandmortyapi.com/api/character", page: page, completion: { responce in
                self.characterers += responce ?? []
                self.tableViewContent.delegate = self
                self.tableViewContent.dataSource = self
                self.tableViewContent.reloadData()
            })
        }
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

