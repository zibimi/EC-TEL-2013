<?php
    header('Content-Type:application/json;charset=utf-8');
    
    $location=isset($_GET['location'])?trim($_GET['location']):'';
    $latitude=isset($_GET['latitude'])?floatval($_GET['latitude']):0;
    $longitude=isset($_GET['longitude'])?floatval($_GET['longitude']):0;
    $url="https://soda.demo.socrata.com/resource/earthquakes.json?".'$where'."=within_circle(location, {$latitude}, {$longitude}, 50000)";
    
    $curl=curl_init($url);
    curl_setopt($curl,CURLOPT_HEADER,0);
    curl_setopt($curl,CURLOPT_RETURNTRANSFER,1);
    $response=curl_exec($curl);
    curl_close($curl);
    exit($response);