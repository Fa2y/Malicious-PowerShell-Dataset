import sys
import base64
import argparse

def xor(data, key):
    return bytes(a ^ b for a, b in zip(data, key * (len(data) // len(key)) + key[:len(data) % len(key)]))

def main():
    parser = argparse.ArgumentParser(description="Decode a Base64 file and XOR its contents with an ASCII key")
    parser.add_argument("input_file", help="Path to the input file containing the Base64 encoded string")
    parser.add_argument("xor_key", help="ASCII string to XOR the decoded contents with")
    parser.add_argument("output_file", help="Path to the output file to save the results")
    
    args = parser.parse_args()

    with open(args.input_file, "r") as infile:
        encoded_data = infile.read()

    decoded_data = base64.b64decode(encoded_data)
    xor_key = args.xor_key.encode("ascii")
    
    xor_result = xor(decoded_data, xor_key)

    with open(args.output_file, "wb") as outfile:
        outfile.write(xor_result)

    print(f"Operation completed. Results saved to {args.output_file}")

if __name__ == "__main__":
    main()
