//
//  ViewController.swift
//  Onde estou
//
//  Created by Rodrigo Abreu on 06/11/17.
//  Copyright © 2017 Rodrigo Abreu. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapa: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    
    @IBOutlet var velocidadeLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longetudeLabel: UILabel!
    @IBOutlet var enderecoLabel: UILabel!
       
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
    }

    //exibir dados de localização do usuario
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let localizacaoUsuario = locations.last
        
        let latitude = localizacaoUsuario!.coordinate.latitude
        let longetude = localizacaoUsuario!.coordinate.longitude
        
        latitudeLabel.text = String(describing: latitude)
        longetudeLabel.text = String(describing: longetude)
        
        if (localizacaoUsuario!.speed > 0) {
            velocidadeLabel.text = String(describing: localizacaoUsuario!.speed)
        }
        
        //exibir o local no mapa (rastrear)
        let deltaLat:CLLocationDegrees = 0.01
        let deltaLon:CLLocationDegrees = 0.01
        
        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longetude)
        let areaExibicao: MKCoordinateSpan = MKCoordinateSpanMake(deltaLat, deltaLon)
        let regiao: MKCoordinateRegion = MKCoordinateRegionMake(localizacao, areaExibicao)
        mapa.setRegion(regiao, animated: true)
        
        
        //exibir endereço conforme lat e lon
        CLGeocoder().reverseGeocodeLocation(localizacaoUsuario!) { (detalhesLocal, erro) in
            
            if erro == nil{
                
                if let dadosLocal = detalhesLocal?.first{
                
                    var thoroughfare = ""
                    if dadosLocal.thoroughfare != nil{
                        thoroughfare = dadosLocal.thoroughfare!
                    }
                    
                    var subThoroughfare = ""
                    if dadosLocal.subThoroughfare != nil{
                        subThoroughfare = dadosLocal.subThoroughfare!
                    }
                    
                    var locality = ""
                    if dadosLocal.locality != nil{
                        locality = dadosLocal.locality!
                    }
                    
                    var subLocality = ""
                    if dadosLocal.subLocality != nil{
                        subLocality = dadosLocal.subLocality!
                    }
                    
                    var postalCode = ""
                    if dadosLocal.postalCode != nil{
                        postalCode = dadosLocal.postalCode!
                    }
                    
                    var country = ""
                    if dadosLocal.country != nil{
                        country = dadosLocal.country!
                    }
                    
                    var administrativeArea = ""
                    if dadosLocal.administrativeArea != nil{
                        administrativeArea = dadosLocal.administrativeArea!
                    }
                    
                    var subAdministrativeArea = ""
                    if dadosLocal.subAdministrativeArea != nil{
                        subAdministrativeArea = dadosLocal.subAdministrativeArea!
                    }
                    
                    /*print(
                        "\n /thoroughfare:" + thoroughfare +
                        "\n /subThoroughfare:" + subThoroughfare +
                        "\n /locality:" + locality +
                        "\n /subLocality:" + subLocality +
                        "\n /postalCode:" + postalCode +
                        "\n /country:" + country +
                        "\n /administrativeArea:" + administrativeArea +
                        "\n /subAdministrativeArea:" + subAdministrativeArea
                    )*/
                    
                    let endereco = thoroughfare + ", "
                                    + subThoroughfare + " - "
                                    + subLocality + " - "
                                    + locality + " / "
                                    + administrativeArea + " - "
                                    + country
                    
                    
                    self.enderecoLabel.text = endereco
                    
                    
                    
                }
                
            }else{
                print(erro!)
            }
            
        }
        
    }
    
    
    //Solicitação de permissão de localização
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse{
            
            let alertaController = UIAlertController(title: "Permissão de localização",
                        message: "Necessário permissão para o acesso à sua localização! por favor habilite.",
                        preferredStyle: .alert)
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default, handler: { (alertaConfiguracoes) in
                
                if let configuracoes = NSURL(string:UIApplicationOpenSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
                
            })
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertaController.addAction(acaoConfiguracoes)
            alertaController.addAction(acaoCancelar)
            
            present(alertaController, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

