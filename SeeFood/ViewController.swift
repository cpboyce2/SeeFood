//
//  ViewController.swift
//  SeeFood
//
//  Created by Connor Boyce on 9/13/19.
//  Copyright © 2019 Connor Boyce. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                 imageView.image = userPickedImage
            guard let coreImage = CIImage(image: userPickedImage) else{
                fatalError("Could not convert to a CI Image")
            }
            detect(image: coreImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)

    }

    func detect(image: CIImage){
        
        // VNCoreMLModel comes from the Vision library
        guard let V3Model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading COREML model failed")
        }
        let request = VNCoreMLRequest(model: V3Model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("There was an error making the request")
            }
            print(results)
        }
        // The handler specifies what image you want to classify

        let handler = VNImageRequestHandler(ciImage: image)

        do{
             try handler.perform([request])
        } catch {
            print(error)
        }

    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
        // Hello
    }

}

