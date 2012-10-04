<?php

/************************************

==== [Example] ====
    C:\programs\php\php config_diff.php C:\server\cfg\gungame\csgo\gungame.config.txt C:\server\cfg\gungame\css\gungame.config.txt 

==== [Credits] ====
    * KawMAN for keyvalue parser (http://forums.alliedmods.net/showpost.php?p=1424641&postcount=4)

*************************************/

if ($argc < 2) {
    echo "Usage: {$argv[0]} <config1> <config2>\n";
    exit(1);
}

$file1 = $argv[1];
$file2 = $argv[2];

if (!file_exists($file1)) {
    echo "File $file1 not found\n";
    exit(2);   
}

if (!file_exists($file2)) {
    echo "File $file2 not found\n";
    exit(2);   
}

//$file1conent = file_get_contents($file1);
//$file2conent = file_get_contents($file2);

class KvParser 
{ 
    private $fhand; 
    private $fend = false; 
    private $comment = false; 
    private $turnoffcomment = false; 
    private $level = 0; 
    private $keyname = array(); 
    private $keyset = array(); 
    private $mykey = array(); 

    public function GetArray($file) 
    { 
        $this->OpenFile($file); 
        while(!$this->fend) 
        { 
            $line = $this->ReadLine(); 
            $pos = 0; 
            $len = strlen($line); 
            while($pos<$len) 
            { 
                if($this->turnoffcomment == true) 
                { 
                    $this->comment = false; 
                    $this->turnoffcomment = false; 
                } 
                $char = substr ( $line , $pos, 1); 
                if($char == " " || $char == "\t" || $char == "\r" || $char == "\n" ) {$pos++; continue; } 
                switch($char) 
                { 
                    case "/": 
                        $char2 = substr($line , $pos, 2); 
                        if($char2 == "/*") { 
                            $this->comment = true; 
                            break; 
                        } 
                        $char2 = substr ( $line , $pos-1, 2); 
                        if($char2 == "*/" && $this->comment == true )  
                        { 
                            $this->turnoffcomment = true; 
                            break; 
                        } 
                     
                } 
                if($this->comment) { $pos++; continue; } 
                 
                switch($char) 
                { 
                    case "{": 
                        $this->level++; 
                        $this->keyset[$this->level] = false; 
                        break; 
                    case "}": 
                        $this->level--; 
                        $this->keyset[$this->level] = false; 
                        break; 
                    case "\"": 
                        $pos2 = strpos($line , "\"", $pos+1); 
                        $val = substr ($line, $pos+1, (($pos2-1)-($pos))); 
                        $pos = $pos2; 
                         
                        if($this->keyset[$this->level] == false) { 
                            $this->keyname[$this->level] = $val; 
                            $this->keyset[$this->level] = true; 
                        } 
                        else { 
                            $this->SetKeyVal($val,$this->level); 
                            $this->keyset[$this->level] = false; 
                        } 
                         
                } 
                $pos++; 
            } 
             
        } 
        $this->CloseFile(); 
        return $this->mykey; 
    } 
     
    private function SetKeyVal($val,$lvl) 
    { 
        $arr = array(); 
        $arr = $this->RecSet($val,$lvl,$arr); 
        $this->mykey = array_merge_recursive($this->mykey, $arr); 
    } 
     
    private function RecSet($val,$lvl,$array,$my=-1) 
    { 
        $my++; 
        if($my==$lvl) 
        { 
            $array[$this->keyname[$my]] = $val; 
        } 
        else 
        { 
            $array[$this->keyname[$my]] = $this->RecSet($val,$lvl,$array,$my); 
        } 
        return $array; 
    } 
    private function ReadLine() 
    { 
        if($this->fend == TRUE) return; 
        if (($buf = fgets($this->fhand)) === false) { 
            $this->fend = true; 
        } else { 
            if (feof($this->fhand)) $this->fend = true; 
            else return $buf; 
        } 
    } 
    private function OpenFile($file) 
    { 
        $this->comment = false; 
        $this->turnoffcomment = false; 
        $this->keyname = array(); 
        $this->keyset = array(); 
        $this->mykey = array(); 
        $this->keyname[0] = "Admins"; 
        $this->level = 0; 
        $this->fhand = @fopen($file, "r"); 
        if($this->fhand == FALSE) $fend = true; 
    } 
    private function CloseFile() 
    { 
        if($this->fhand != FALSE) fclose($this->fhand); 
    } 
}  

$parser = new KvParser;
$file1parsed = $parser->GetArray($file1);
$parser = new KvParser;
$file2parsed = $parser->GetArray($file2);

function makeDiff(&$diff, $fileparsed, $parentKey, $fileNum) {
    foreach($fileparsed as $key=>$value) {
        $path = $parentKey."/$key";
        if (!is_array($value)) {
            $diff[$path][$fileNum] = $value;
        } else {
            makeDiff($diff, $value, $path, $fileNum);
        }
    }
}

$diff = array();
makeDiff($diff, $file1parsed, "", 1);
makeDiff($diff, $file2parsed, "", 2);

function countMaxLen($diff, &$maxkey, &$maxval1, &$maxval2) {
    $maxkey = $maxval1 = $maxval2 = 0;
    foreach($diff as $key=>$value) {
        if (strlen($key) > $maxkey) {
            $maxkey = strlen($key);
        }
        if (isset($value[1]) && (strlen($value[1]) > $maxval1)) {
            $maxval1 = strlen($value[1]);
        }
        if (isset($value[2]) && (strlen($value[2]) > $maxval2)) {
            $maxval2 = strlen($value[2]);
        }
    }
}

$maxkey = $maxval1 = $maxval2 = 0;
countMaxLen($diff, $maxkey, $maxval1, $maxval2);

function printDiff($diff, $maxkey, $maxval1, $maxval2, $file1, $file2) {
    printf("FILE1 = %s\n", $file1);
    printf("FILE2 = %s\n", $file2);
    printf("| %-'-{$maxkey}s | %-'-{$maxval1}s | %-'-{$maxval2}s |\n", "----", "----", "----");
    printf("| %-{$maxkey}s | %-{$maxval1}s | %-{$maxval2}s |\n", "[KEY]", "[FILE1]", "[FILE2]");
    printf("| %-'-{$maxkey}s | %-'-{$maxval1}s | %-'-{$maxval2}s |\n", "----", "----", "----");
    foreach($diff as $key=>$value) {
        $showDiff = false;
        if (!isset($value[1])) {
            $value[1] = "<NULL>";
            $showDiff = true;
        } elseif (!isset($value[2])) {
            $value[2] = "<NULL>";
            $showDiff = true;
        } elseif ($value[1] !== $value[2]) {
            $showDiff = true;
        }

        if ($showDiff) {
            printf("| %-{$maxkey}s | %-{$maxval1}s | %-{$maxval2}s |\n", $key, $value[1], $value[2]);
        }
    }       
    printf("| %-'-{$maxkey}s | %-'-{$maxval1}s | %-'-{$maxval2}s |\n", "----", "----", "----");
}

printDiff($diff, $maxkey, $maxval1, $maxval2, $file1, $file2);
