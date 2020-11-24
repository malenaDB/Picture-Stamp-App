//
//  ViewController.swift
//  MustacheMe
//
//  Created by Christopher Walter on 11/3/17.
//  Copyright © 2017 AssistStat. All rights reserved.
//

import UIKit

// Added UIImagePickerController Delegate to access camera
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var mySecondCollectionView: UICollectionView!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var selectedTheme = Theme()
    var selectedStamp = "bigH"
    
    // create global variable for UIImagePicker
    let picker = UIImagePickerController()
    
    var themes = [Theme]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // set imagePickers delegate to self
        picker.delegate = self
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        mySecondCollectionView.delegate = self
        mySecondCollectionView.dataSource = self
        
        loadThemes()
    }
    
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer)
    {
        // ToDo: What do we want to have happen after we tap an image?
        
        // here, we are figuring out which exact point we tapped in the image view
        let location = sender.location(in: myImageView)
        
        // here, we are creating an image view for the mustache.  The x and y values for the location of the image view are just the x and y values from the location variable (location of where the user tapped) that we made above.
        let newMustache = UIImageView(frame: CGRect(x: location.x, y: location.y, width: 60, height: 60))

        
        // without this line of code, the top left corner of the mustache, which is the point (0,0) on the mustache, the corner of the mustache shows up at the point on the image view where the user tapped.  This makes the mustache be off to the side.  So, here we are saying that the center of the mustache is the location variable (where the user taps), so it all lines up nicely.
        newMustache.center = location
        
        newMustache.image = UIImage(named: selectedStamp)
        myImageView.addSubview(newMustache)
        
        // here, we are creating a tag for the mustache, so every single newMustache image view that is created will have this tag.  This will make it easy to refer to all of the mustache imageViews at once.
        newMustache.tag = 1
        
        // programtically make pan gesture on mustache
        let pan = UIPanGestureRecognizer(target: self, action: #selector(mustachePanned(_:)))
        newMustache.addGestureRecognizer(pan)
        // this just makes it so that the user can interact with the mustache so that the pan gesture works!
        newMustache.isUserInteractionEnabled = true
        
        
    }
    
    @objc func mustachePanned(_ sender: UIPanGestureRecognizer)
    {
        // figure out which mustache is being touched
        let mustache = sender.view
        // change the mustache's center to be the location of the user's finger as they drag the mustache on the image view
        mustache?.center = sender.location(in: myImageView)
    }
    

    @IBAction func cameraButtonSelected(_ sender: UIBarButtonItem)
    {
        cameraAlert()
    }
    
    func cameraAlert()
    {
        let alert = UIAlertController(title: "Select where to get image from", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let libraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default) { (action) in
            //ToDo
            self.picker.sourceType = .photoLibrary
            
            // set up any other features of the camera that you want
            self.present(self.picker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        { (action) in
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil
            {
                //To Do
            }
            else
            {
                self.noCamera()
            }
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        {(action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(libraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clearButtonSelected(_ sender: UIBarButtonItem)
    {
        for subview in myImageView.subviews
        {
            if subview.tag == 1
            {
                subview.removeFromSuperview()
            }
        }
    }
    
    func noCamera()
    {
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
        
    // Make sure you add privacy warnings on info.plist
    
    // this is what will happen if someone clicks the cancel button when offered to pick a picture from their camera roll
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // this is what will happen if someone does choose to pick a picture from their camera roll
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        print(info)
        
        // the as? UIImage at the end of that code snippet below is casting whatever is inside of the brackets into a UIImage --> so it is basically just making it a UIImage
        if let myImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            myImageView.image = myImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func loadThemes()
    {
        let bowties = Theme(t: "ties", i: ["redBowtie", "yellowBowtie", "redStripeBowtie", "yellowStripeBowtie", "redDotBowtie", "yellowDotBowtie"])
        let ties = Theme(t: "ties", i: ["redTie", "yellowTie", "redStripeTie", "yellowStripeTie"])
        let hats = Theme(t: "hats", i: ["redHat", "yellowHat", "redHatH", "yellowHatH"])
        let masks = Theme(t: "masks", i: ["redMask", "yellowMask", "redStripeMask", "yellowStripeMask", "redMaskH", "yellowMaskH", "redMaskHStripe", "yellowMaskHStripe"])
        let flags = Theme(t: "flags", i: ["redFlag", "yellowFlag", "redFlagH", "yellowFlagH", "bigH"])
        let megaphones = Theme(t: "megaphones", i: ["redMegaphone", "yellowMegaphone", "redStripeMegaphone", "yellowStripeMegaphone", "redMegaphoneH", "yellowMegaphoneH"])
    
        themes.append(bowties)
        themes.append(ties)
        themes.append(hats)
        themes.append(masks)
        themes.append(megaphones)
        themes.append(flags)
        
        selectedTheme = themes[0]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == myCollectionView
        {
            return themes.count
        }
        else
        {
            return selectedTheme.images.count
        }
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == myCollectionView
        {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MyCollectionViewCell
            var currentTheme = themes[indexPath.row]
            var defaultPicture = currentTheme.images[0]
            cell.myImageView.image = UIImage(named: defaultPicture)
           // cell.backgroundColor = UIColor.systemGray2
           // Configure the cell
              return cell
        }
        else
        {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MyCollectionViewCell
            print(selectedTheme.theme + "in cell")
            print(selectedTheme.images)
            print(indexPath)
            let currentPicture = selectedTheme.images[indexPath.row]
            cell.myImageView.image = UIImage(named: currentPicture)
               // Configure the cell
               return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == myCollectionView
        {
            selectedTheme = themes[indexPath.row]
            print(selectedTheme.theme)
            mySecondCollectionView.reloadData()
        }
        else
        {
            selectedStamp = selectedTheme.images[indexPath.row]
        }
    }
}

