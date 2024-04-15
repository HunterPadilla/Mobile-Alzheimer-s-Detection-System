//
//  ConfirmAndUploadViewController.swift
//  AlzDetection
//
//  Created by Hunter Padilla on 3/27/24.
//

import UIKit

import Amplify
import AWSCognitoAuthPlugin

import QuickPoseCore

import xlsxwriter
import Foundation

struct userInfo{
    //Stores the Username of the user logged in
    public static var username = ""
}


class ConfirmAndUploadViewController: UIViewController {
    
    //A lot of class wide variables...
    //Filename is created using the username of the current Auth session
    let tmpFileName = "export_dataPoints.xls"
    var destinationPath: String = ""
    var workbook: UnsafeMutablePointer<lxw_workbook>?
    var worksheet: UnsafeMutablePointer<lxw_worksheet>?
    var formatHeader: UnsafeMutablePointer<lxw_format>?
    var format1: UnsafeMutablePointer<lxw_format>?
    private var writingLine: UInt32 = 0
    private var needWriterPreparation = false
    
    //This function simply restarts the recording process if the user wishes to attemp the task again.
    @IBAction func reRecordButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "reRecord", sender: self)
    }
    
    //Prepares the Excel sheet and then finalizes it using export()
    //NOTE: in the future, export() can be removed and called from anywhere to build/complete the file such as after data collection is properly implemented
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Forces an async function to occur on viewDidLoad to grab the username and store it in the struct
        Task{await nameTheFile()}
        prepareXlsWriter()
        export()
    }
    
    func nameTheFile() async{
        do{
            let username = try await Amplify.Auth.getCurrentUser().username
            userInfo.username = username
            
        }
        catch{
            return
        }
    }
    
    
    //This function creates a temporary doc directory for the file to use
    private func docDirectoryPath() -> String {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return dirPaths[0]
    }
    
    

    //This function prepares the XLS writer so we have a proper file path, and proper workbook/worksheet defined
    private func prepareXlsWriter() {
        let directoryPath = docDirectoryPath()
        destinationPath = (directoryPath as NSString).appendingPathComponent(tmpFileName)
        workbook = workbook_new(destinationPath)
        worksheet = workbook_add_worksheet(workbook, nil)
        formatHeader = workbook_add_format(workbook)
        format_set_bold(formatHeader)
        format1 = workbook_add_format(workbook)
        format_set_bg_color(format1, 0xDDDDDD)
        needWriterPreparation = true
        print(destinationPath)
    }
    
    //This function builds the headers for each column and assigns the rows underneath it
    private func buildHeader() {
        writingLine = 0
        let format = formatHeader
        format_set_bold(format)
        worksheet_write_string(worksheet, writingLine, 0, "leftWaist", format)
        worksheet_write_string(worksheet, writingLine + 1, 0, "x_value", format)
        worksheet_write_string(worksheet, writingLine + 2, 0, "y_value", format)
        worksheet_write_string(worksheet, writingLine + 3, 0, "z_value", format)
        
        worksheet_write_string(worksheet, writingLine, 1, "rightWaist", format)
        worksheet_write_string(worksheet, writingLine + 1, 1, "x_value", format)
        worksheet_write_string(worksheet, writingLine + 2, 1, "y_value", format)
        worksheet_write_string(worksheet, writingLine + 3, 1, "z_value", format)
        
        worksheet_write_string(worksheet, writingLine, 2, "leftShoulder", format)
        worksheet_write_string(worksheet, writingLine + 1, 2, "x_value", format)
        worksheet_write_string(worksheet, writingLine + 2, 2, "y_value", format)
        worksheet_write_string(worksheet, writingLine + 3, 2, "z_value", format)
        
        worksheet_write_string(worksheet, writingLine, 3, "rightShoulder", format)
        worksheet_write_string(worksheet, writingLine + 1, 3, "x_value", format)
        worksheet_write_string(worksheet, writingLine + 2, 3, "y_value", format)
        worksheet_write_string(worksheet, writingLine + 3, 3, "z_value", format)
    }
    
    //This function actually writes the values in for each row that was specified under the headers, using data from the Database class.
    private func buildNewLine(product: Product) {
        let lineFormat = (writingLine % 2 == 1) ? format1 : nil
        
        // Write leftWaist measurements
        worksheet_write_number(worksheet, writingLine + 1, 0, product.leftWaist.x_value, lineFormat)
        worksheet_write_number(worksheet, writingLine + 2, 0, product.leftWaist.y_value, lineFormat)
        worksheet_write_number(worksheet, writingLine + 3, 0, product.leftWaist.z_value, lineFormat)
        
        // Write rightWaist measurements
        worksheet_write_number(worksheet, writingLine + 1, 1, product.rightWaist.x_value, lineFormat)
        worksheet_write_number(worksheet, writingLine + 2, 1, product.rightWaist.y_value, lineFormat)
        worksheet_write_number(worksheet, writingLine + 3, 1, product.rightWaist.z_value, lineFormat)
        
        // Write leftShoulder measurements
        worksheet_write_number(worksheet, writingLine + 1, 2, product.leftShoulder.x_value, lineFormat)
        worksheet_write_number(worksheet, writingLine + 2, 2, product.leftShoulder.y_value, lineFormat)
        worksheet_write_number(worksheet, writingLine + 3, 2, product.leftShoulder.z_value, lineFormat)
        
        // Write rightShoulder measurements
        worksheet_write_number(worksheet, writingLine + 1, 3, product.rightShoulder.x_value, lineFormat)
        worksheet_write_number(worksheet, writingLine + 2, 3, product.rightShoulder.y_value, lineFormat)
        worksheet_write_number(worksheet, writingLine + 3, 3, product.rightShoulder.z_value, lineFormat)
        
        writingLine += 4 // Move to the next set of measurements
    }
    
    //This function handles the creation of the database, and other necessary function calls
    private func export() {
        if needWriterPreparation {
            buildHeader()
            let productList = Database().productList
            for product in productList {
                buildNewLine(product: product)
            }
            workbook_close(workbook)
            needWriterPreparation = false
        }
    }
    
    
    
    
    
    
    //This button function is what triggers the uploading of the data in the form of a spreadsheet to S3
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        Task { @MainActor in
            
            //Set the file name for the upload to S3
            //These few lines set the filename to be unique to every userID that is logged in.
        
            let fileName = "export_dataPoints.xls"
            
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }

            let filePath = documentDirectory.appendingPathComponent(fileName)
            print(filePath)
            // Upload the Excel file to Amazon S3
            do {
                let uploadTask = Amplify.Storage.uploadFile(key: "\(userInfo.username)_dataPoints.xls", local: filePath)

                Task {
                    for await progress in await uploadTask.progress {
                        print("Progress: \(progress)")
                    }
                }
                
                //Only complete the segue if the upload to S3 completes as well
                let data = try await uploadTask.value
                print("Completed: \(data)")
                self.performSegue(withIdentifier: "uploadSuccess", sender: self)

            } catch {
                print("Error uploading file to S3: \(error)")
            }
        }
    }
}

//These hold the values for the X,Y, and Z coordinates in each Joint
struct Measurement {
    var x_value: Double
    var y_value: Double
    var z_value: Double
}

//This struct holds the Joint variables
struct Product {
    var leftWaist: Measurement
    var rightWaist: Measurement
    var leftShoulder: Measurement
    var rightShoulder: Measurement
}

//This Database stores the positional data from the coordinates which is then tied to each column
class Database {
    lazy var productList: [Product] = {
        return [
            //This is where the data is entered for the Excel Sheet
            //In the future, this can be changed to take values of type double to store the coordinate data from pose estimation
            Product(leftWaist: Measurement(x_value: 1.0, y_value: 2.0, z_value: 3.0),
                    rightWaist: Measurement(x_value: 4.0, y_value: 5.0, z_value: 6.0),
                    leftShoulder: Measurement(x_value: 7.0, y_value: 8.0, z_value: 9.0),
                    rightShoulder: Measurement(x_value: 10.0, y_value: 11.0, z_value: 12.0))
        ]
    }()
}
