

# #########################################################################################
# # Download All 2020,21,22 data
# #########################################################################################
# # setting the output directory
# outdir="results/main/cmi_pb_datasets/raw/"

# # links are coming from: 
# # https://www.cmi-pb.org/downloads/cmipb_challenge_datasets/2nd_cmipb_challenge/10202022/

# wget --no-check-certificate \
#      --no-directories \
#      --recursive \
#      --no-parent \
#      --directory-prefix $outdir \
#      https://www.cmi-pb.org/downloads/cmipb_challenge_datasets/2nd_cmipb_challenge/11282022/
     
#     # https://www.cmi-pb.org/downloads/cmipb_challenge_datasets/2nd_cmipb_challenge/10202022/


#########################################################################################
# Download All 2020,21,22 Pramod processed data
#########################################################################################
# setting the output directory
outdir="results/main/cmi_pb_datasets/ps-processed-data/"

# links are coming from: 
# https://www.cmi-pb.org/downloads/cmipb_challenge_datasets/current/2nd_challenge/processed_datasets/master_processed_training_data_TSVs/

wget --no-check-certificate \
     --no-directories \
     --recursive \
     --no-parent \
     --directory-prefix $outdir \
     https://www.cmi-pb.org/downloads/cmipb_challenge_datasets/current/2nd_challenge/processed_datasets/master_processed_training_data_TSVs/


