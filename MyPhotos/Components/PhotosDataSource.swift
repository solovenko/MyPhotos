//
//  PhotosDataSource.swift
//  MyPhotos
//
//  Created by Артем Соловьенко on 04.11.16.
//  Copyright © 2016 Artem Solovenko. All rights reserved.
//

import UIKit

class PhotosDataSource: NSObject {

}

extension PhotosDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.cellId, for: indexPath)
        return cell
    }
}
