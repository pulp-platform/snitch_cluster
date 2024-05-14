import os

text = 'amo_op_e'
path = '/scratch/bsc24f10/Documents/MonocerosGithubRepo/monoceros/snitch_cluster/hw'

def searchText(path):

	os.chdir(path)
	files = os.listdir(path)
	#print(files)

	for file_name in files:
		abs_path = os.path.join(path, file_name)
		#print('is '+ abs_path + ' directory? : ')
		if os.path.isdir(abs_path):
			#print("Directory found: " + abs_path)
			searchText(abs_path)

		if os.path.isfile(abs_path):
			#print("File found: " + abs_path)
			with open(abs_path, 'r') as f:
				if text in f.read():
					final_path = os.path.abspath(file_name)
					print(text + " word found in this path " + final_path)
	pass
searchText(path)
print("DONE")
