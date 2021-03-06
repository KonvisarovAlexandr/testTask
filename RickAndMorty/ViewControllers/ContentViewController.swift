//
//  ContentViewController.swift
//  RickAndMorty


import UIKit

class ContentViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{


    @IBOutlet weak var aliveCircle: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seeAlsoTableView: UITableView!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterLocation: UILabel!
    @IBOutlet weak var charterLocationPast: UILabel!
    @IBOutlet weak var characterStatus: UILabel!
    var parentVC:InitialViewController? = nil
    var delegate:Delegate? = nil
    var character:Character? = nil
    var characterers:[Character] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nameLabel.text = self.character?.name
        parentVC?.checkIfImageIsInCoreDataAndSetIt(whereToSet: &self.characterImage, characterWhichIdChecking: self.character! )
//        self.characterImage.loadImageUsingCache(withUrl: self.character?.image){_ in }
        self.characterLocation.text = self.character?.location.name
        self.charterLocationPast.text = self.character?.origin.name
        self.characterStatus.text = self.character?.status
        switch self.character?.status {
        case "Alive":
            self.aliveCircle.tintColor = .green
        case "Dead":
            self.aliveCircle.tintColor = .red
        case "unknown":
            self.aliveCircle.tintColor = .gray
        case .none:
            self.aliveCircle.tintColor = .clear
        case .some(_):
            self.aliveCircle.tintColor = .yellow
        }
        NetworkManager.shared.getCharactersByEpisode(selfId: "\(self.character?.id ?? 0)", episodeUrl:character?.location.url ?? "", completion: { responce in
            self.characterers = responce ?? []
            self.seeAlsoTableView.delegate = self
            self.seeAlsoTableView.dataSource = self
            self.seeAlsoTableView.reloadData()
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        seeAlsoTableView.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: "CharacterTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false)
        delegate?.dissmissAndShowNewCharacter(character: characterers[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell") as! CharacterTableViewCell
        cell.nameLabel.text = self.characterers[indexPath.row].name
        cell.locationName.text = self.characterers[indexPath.row].location.name
        parentVC?.checkIfImageIsInCoreDataAndSetIt(whereToSet: &cell.characterImage, characterWhichIdChecking: characterers[indexPath.row])
//        cell.characterImage.loadImageUsingCache(withUrl: self.characterers[indexPath.row].image){_ in }
        NetworkManager.shared.getOneEpizode(url:characterers[indexPath.row].episode.first ?? "", completion: { episodeName in
            cell.episodeName.text = episodeName?.name
        })
        
        return cell
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
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

protocol Delegate{
    func dissmissAndShowNewCharacter(character:Character)
}
