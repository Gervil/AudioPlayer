//
//  ListadoTableViewController.swift
//  AudioPlayer
//
//  Created by Gerardo Villarroel on 01-08-16.
//  Copyright © 2016 Gerardo Villarroel. All rights reserved.
//

import UIKit

class ListadoTableViewController: UITableViewController {
    let tema = RocolaStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tema.listadoDeCanciones.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = "\(indexPath.row + 1). " + self.tema.listadoArtistas[indexPath.row]
        cell.detailTextLabel?.text = self.tema.listadoDeCanciones[indexPath.row]
        cell.imageView?.image = UIImage(named: self.tema.listadoArtistas[indexPath.row])
        
        //Cambio de tamaño de las imágenes en el listado.
        let itemSize: CGSize = CGSize(width: 300, height: 300)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.mainScreen().scale)
        let imageRect: CGRect = CGRectMake(0, 10, itemSize.width, itemSize.height)
        cell.imageView!.image?.drawInRect(imageRect)
        cell.imageView!.image? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let segue = segue.destinationViewController as! ViewController
        let rutaIndice = self.tableView.indexPathForSelectedRow
        segue.storage = rutaIndice!.row
        segue.tema = self.tema
    }
}
