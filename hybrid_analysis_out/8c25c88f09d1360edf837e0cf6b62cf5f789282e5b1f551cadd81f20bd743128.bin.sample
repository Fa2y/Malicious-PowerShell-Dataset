# barev dzez boss, I have created a bunch of obfuscation functions. 
# I stored the AES Key to our ransomware somewhere safe. They will never find it -> $haha = decode('30386432363039653166373135626465636637396538393566666135383937363130316662636566326134383262363837383465306130303533366235373962')

function Kotor($s) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($s)
    $result = [System.Convert]::ToBase64String($bytes)
    return $result
}

function Trogir($s, $key) {
    $result = ""
    for ($i = 0; $i -lt $s.Length; $i++) {
        $byte = [byte]$s[$i] -bxor [byte]$key[$i % $key.Length]
        $result += [System.Convert]::ToString($byte, 16).PadLeft(2, '0')
    }
    return $result
}

function Chefchaouen($s) {
    $result = ""
    for ($i = 0; $i -lt $s.Length; $i++) {
        $c = [char]$s[$i]
        if ($c -cmatch "[a-m]") {
            $result += [char]([int]$c + 13)
        } elseif ($c -cmatch "[n-z]") {
            $result += [char]([int]$c - 13)
        } else {
            $result += $c
        }
    }
    return $result
}

function Ouarzazate($s) {
    $result = [char[]]$s
    [array]::Reverse($result)
    return [string]$result
}

function Goris($s) {
    $r = ""
    for ($i = 0; $i -lt $s.Length; $i++) {
        $c = [int][char]$s[$i]
        $r += [System.Convert]::ToString($c, 16).PadLeft(2, '0')
    }
    return $r
}

function Ushuaia($s, $shift) {
    $result = ""
    $shift = $shift % 26
    for ($i = 0; $i -lt $s.Length; $i++) {
        $c = [char]$s[$i]
        if ($c -cmatch "[a-z]") {
            $result += [char](([int]$c + $shift - 97) % 26 + 97)
        } elseif ($c -cmatch "[A-Z]") {
            $result += [char](([int]$c + $shift - 65) % 26 + 65)
        } else {
            $result += $c
        }
    }
    return $result
}

function Xitang($s) {
    $result = ""
    for ($i = 0; $i -lt $s.Length; $i++) {
        $byte = [byte]$s[$i]
        $not = -bnot $byte
        $result += [System.Convert]::ToString($not, 16).PadLeft(2, '0')
    }
    return $result
}

function Ksamil($s) {
    $result = ""
    for ($i = 0; $i -lt $s.Length; $i++) {
        $byte = [byte]$s[$i]
        $result += [System.Convert]::ToString($byte, 16).PadLeft(2, '0')
    }
    return $result
}

function Tarija($s, $shift) {
    $result = ""
    $shift = $shift % 256
    for ($i = 0; $i -lt $s.Length; $i++) {
        $byte = [byte]$s[$i]
        $shifted = ($byte + $shift) % 256
        $result += [char]$shifted
    }
    return $result
}

function decode($X) {
$X = Chefchaouen($X)
$X = Ouarzazate($X)
$X = Ushuaia($X, 7)
$X = Ksamil($X)
$X = Trogir($X, "92!J8D*2@%!fKj#")
$X = Xitang($X)
$X = Tarija($X, 183)
$result = Goris($X)
return $result
}


$haha = decode('30386432363039653166373135626465636637396538393566666135383937363130316662636566326134383262363837383465306130303533366235373962')


$keyUrl = 'https://hunttheflag.draftdownlabs.com/' + $haha
$keyBytes = [System.Convert]::FromBase64String((Invoke-WebRequest -Uri $keyUrl))


$ciphertext = [System.Convert]::FromBase64String("lJsslE0jPm6E/bNR335l0UhQmt8LbQ/XdKdj4GoSlU8=")

# Create an AES object with the specified key and initialization vector
$aes = New-Object System.Security.Cryptography.AesCryptoServiceProvider
$aes.Mode = [System.Security.Cryptography.CipherMode]::CFB
$aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
$aes.Key = $keyBytes
$aes.IV = ([System.Convert]::FromBase64String("pNiTwHP+UPTSCy/0X//jMg=="))

# Create a decryptor object and decrypt the ciphertext
$decryptor = $aes.CreateDecryptor()
$plaintext = $decryptor.TransformFinalBlock($ciphertext, 0, $ciphertext.Length)

# Output the decrypted flag as a string
[System.Text.Encoding]::UTF8.GetString($plaintext).TrimEnd([Char]0)

