//
//  InitialViewController.swift
//  RickAndMorty

import UIKit

class InitialViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,Delegate{
    
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
            vc?.delegate = self
            vc?.modalTransitionStyle = .crossDissolve
            vc?.modalPresentationStyle = .fullScreen
            return vc
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getCharacters(url:"https://rickandmortyapi.com/api/character", page: page, completion: { responce in
            self.characterers = responce ?? []
            self.tableViewContent.delegate = self
            self.tableViewContent.dataSource = self
            self.tableViewContent.reloadData()
        })
        // Do any additional setup after loading the view.
        tableViewContent.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: "CharacterTableViewCell")
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell") as! CharacterTableViewCell
        cell.nameLabel.text = self.characterers[indexPath.row].name
        cell.locationName.text = self.characterers[indexPath.row].location.name
        cell.characterImage.loadImageUsingCache(withUrl: self.characterers[indexPath.row].image){}
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

