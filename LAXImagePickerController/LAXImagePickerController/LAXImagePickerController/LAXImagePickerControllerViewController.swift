//
//  LAXImagePickerController.swift
//  MeiLiTV
//
//  Created by 冰凉的枷锁 on 2017/3/31.
//  Copyright © 2017年 冰凉的枷锁. All rights reserved.
//

import UIKit

class LAXImagePickerController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePickerController = UIImagePickerController()
    var didFinishPickingBlock: ((_ image: UIImage?) -> Void)?
    var imageSize = CGSize.init(width: 100, height: 100)
    var imageName = "image.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.modalTransitionStyle = .flipHorizontal
        imagePickerController.allowsEditing = true
    }
    
    func showCamera() {//UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            self.show(imagePickerController, sender: nil)
        } else {
            let alert = UIAlertController.init(title: "提示", message: "没有检测到摄像头", preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.show(alert, sender: nil)
        }
    }
    
    private func showPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.show(imagePickerController, sender: nil)
        } else {
            let alert = UIAlertController.init(title: "提示", message: "不能打开相册", preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.show(alert, sender: nil)
        }
    }
    
    func showImagePickerController() {
        let sheet = UIAlertController.init(title: "请选择", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let camera = UIAlertAction.init(title: "拍照", style: .default) {(alert) in
            self.showCamera()
        }
        let photo = UIAlertAction.init(title: "相册", style: .default) {(alert) in
            self.showPhotoLibrary()
        }
        sheet.addAction(camera)
        sheet.addAction(photo)
        sheet.addAction(cancel)
        self.show(sheet, sender: nil)
    }
    
    //保存图片至沙盒
    private func saveImage(currentImage: UIImage, persent: CGFloat, imageName: String){
        if let imageData = UIImageJPEGRepresentation(currentImage, persent) as NSData? {
            let fullPath = NSHomeDirectory().appending("/Documents/").appending(imageName)
            imageData.write(toFile: fullPath, atomically: true)
            print("fullPath=\(fullPath)")
        }
    }
    
    private func saveImage(currentImage: UIImage, newSize: CGSize, imageName: String){
        //压缩图片尺寸
        UIGraphicsBeginImageContext(newSize)
        currentImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
            if let imageData = UIImageJPEGRepresentation(newImage, 1) as NSData? {
                let fullPath = NSHomeDirectory().appending("/Documents/").appending(imageName)
                imageData.write(toFile: fullPath, atomically: true)
                print("fullPath=\(fullPath)")
            }
        }
    }
    
    //MARK:- UIImagePickerControllerDelegate
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String :Any]){
        
        var image: UIImage?
        
        if(picker.allowsEditing){
            //裁剪后图片
            image = info[UIImagePickerControllerEditedImage] as? UIImage
        }else{
            //原始图片
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        if image != nil {
            saveImage(currentImage: image!, newSize: imageSize, imageName: imageName)
            let fullPath = NSHomeDirectory().appending("/Documents/").appending(imageName)
            let savedImage: UIImage = UIImage(contentsOfFile: fullPath)!
            didFinishPickingBlock?(savedImage)
            //在这里调用网络通讯方法，上传头像至服务器...
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController){
        picker.dismiss(animated:true, completion:nil)
    }
    
}
