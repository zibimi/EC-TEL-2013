<?php
    // https://github.com/uber/coding-challenge-tools/blob/master/coding_challenge.md
    // https://data.sfgov.org/Culture-and-Recreation/Film-Locations-in-San-Francisco/yitu-d5am?
    
    header('Content-Type:application/json;charset=utf-8');
    
    $title=isset($_GET['title'])?trim($_GET['title']):'';
    $releaseyear=isset($_GET['releaseyear'])?trim($_GET['releaseyear']):'';
    $director=isset($_GET['director'])?trim($_GET['director']):'';
    
    $data=array();
    if($title!=''){
       $data['title']=$title;
    }
    if($releaseyear!=''){
        $data['release_year']=$releaseyear;
    }
    if($director!=''){
        $data['director']=$director;
    }
    
    $query=http_build_query($data);
    
    $url='http://data.sfgov.org/resource/yitu-d5am.json?'.$query;
    
    $curl=curl_init($url);
    curl_setopt($curl,CURLOPT_HEADER,0);
    curl_setopt($curl,CURLOPT_RETURNTRANSFER,1);
    $response=curl_exec($curl);
    curl_close($curl);
    exit($response);