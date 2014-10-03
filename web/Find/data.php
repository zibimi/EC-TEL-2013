<?php

	$restaurant_arr = array( 

	    '0' => array('id'=>1,'min'=>1,'max'=>12,'name'=>'Korea Garden','v'=>1), 

	    '1' => array('id'=>2,'min'=>13,'max'=>24,'name'=>'CATHEDRAL','v'=>2), 

	    '2' => array('id'=>3,'min'=>25,'max'=>36,'name'=>'Noodles & Company','v'=>3),

	    '3' => array('id'=>4,'min'=>37,'max'=>48,'name'=>'QQ Noodle','v'=>4),

	    '4' => array('id'=>5,'min'=>49,'max'=>60,'name'=>'Ming Tasty','v'=>5),

	    '5' => array('id'=>6,'min'=>61,'max'=>72,'name'=>'Popeyes','v'=>6),

	    '6' => array('id'=>7,'min'=>73,'max'=>84,'name'=>'Yokoso','v'=>7),

	    '7' => array('id'=>8,'min'=>85,'max'=>96,'name'=>'Avenu B','v'=>8),

	    '8' => array('id'=>9,'min'=>97,'max'=>108,'name'=>'Fu Lan Mum','v'=>9),

	    '9' => array('id'=>10,'min'=>109,'max'=>120,'name'=>'Chef ZHAO','v'=>10),

	    '10' => array('id'=>11,'min'=>121,'max'=>132,'name'=>'CHEESECAKE','v'=>11),

	    '11' => array('id'=>12,'min'=>133,'max'=>144,'name'=>'Red Lobster','v'=>12),

	    '12' => array('id'=>13,'min'=>145,'max'=>156,'name'=>'LuLu Noodles','v'=>13),

	    '13' => array('id'=>14,'min'=>157,'max'=>168,'name'=>'Misaki Buffet','v'=>14),

	    '14' => array('id'=>15,'min'=>169,'max'=>180,'name'=>'Outback','v'=>15), 

	    '15' => array('id'=>16,'min'=>181,'max'=>192,'name'=>'Beijing','v'=>16), 

	    '16' => array('id'=>17,'min'=>193,'max'=>204,'name'=>'Jang Su Jang','v'=>17), 

	    '17' => array('id'=>18,'min'=>205,'max'=>216,'name'=>'Guan Dong','v'=>18), 

	    '18' => array('id'=>19,'min'=>217,'max'=>228,'name'=>'Misoya','v'=>19),

	    '19' => array('id'=>20,'min'=>229,'max'=>240,'name'=>'China Stix','v'=>20),

	    '20' => array('id'=>21,'min'=>241,'max'=>252,'name'=>'Teppanyaki Kyoto','v'=>21),

	    '21' => array('id'=>22,'min'=>253,'max'=>264,'name'=>'Benihana','v'=>22),

	    '22' => array('id'=>23,'min'=>265,'max'=>276,'name'=>'Sushi Tomo','v'=>23),

	    '23' => array('id'=>24,'min'=>277,'max'=>288,'name'=>'Noodlehead','v'=>24),

	    '24' => array('id'=>25,'min'=>289,'max'=>300,'name'=>'China Palace','v'=>25),

	    '25' => array('id'=>26,'min'=>301,'max'=>312,'name'=>'Miss Saigon 88 Cafe','v'=>26),

	    '26' => array('id'=>27,'min'=>313,'max'=>324,'name'=>'Sun Penang','v'=>27),

	    '27' => array('id'=>28,'min'=>325,'max'=>336,'name'=>'Rose Tea','v'=>28),

	    '28' => array('id'=>29,'min'=>337,'max'=>348,'name'=>'Spice Island Tea House','v'=>29),

	    '29' => array('id'=>30,'min'=>349,'max'=>360,'name'=>'Shanghai Graden','v'=>30)

	); 



#function weight($proArr){	

#	$result = ''; 

#   $proSum = array_sum($proArr); 

#    foreach ($proArr as $key => $proCur) { 

#        $randNum = mt_rand(1, $proSum); 

#        if ($randNum <= $proCur) { 

#            $result = $key; 

#            break; 

#        } else { 

#            $proSum -= $proCur; 

#        } 

#    } 

#    unset ($proArr);

#    return $result; 

#} 



	function getRand($proArr){

		$proSum = count($proArr);

		$randNum = rand(1,$proSum);

		unset($proArr);

		return $randNum;

	}



	function wphp_urlencode($data) {

		if (is_array($data) || is_object($data)) {

			foreach ($data as $k => $v) {

				if (is_scalar($v)) {

					if (is_array($data)) {

						$data[$k] = urlencode($v);

					} else if (is_object($data)) {

						$data->$k = urlencode($v);

					}

				} else if (is_array($data)) {

					$data[$k] = wphp_urlencode($v); 

				} else if (is_object($data)) {

					$data->$k = wphp_urlencode($v);

				}

			}

		}

		return $data;

	}

		

	function ch_json_encode($data) {	

		$ret = wphp_urlencode($data);

		$ret = json_encode($ret);

		return urldecode($ret);

	}



	foreach ($restaurant_arr as $key => $val) {

		$arr[$val['id']] = $val['v'];

	}

	$rid = getRand($arr);

	$res = $restaurant_arr[$rid-1];

	$min = $res['min'];

	$max = $res['max'];

	$restaurant['angle'] = rand($min,$max);

	$restaurant['rname'] = $res['name'];

	echo json_encode($restaurant);

?>



