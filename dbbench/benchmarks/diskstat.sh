#awk '{ print "reads: ",$4,"\nreadMerged: ",$5,"\nr_sector: ",$6,"\nms_read: ",$7,"\nwrites: ",$8,"\nsect_written: ",$10,"\nwriteMerged: ",$9,"\nms_write", $11 }' < vda_stats.start

reads_start=$(awk '{print $4}' < vda_stats.start)
readSect_start=$(awk '{print $6}' < vda_stats.start)
readMs_start=$(awk '{print $7}' < vda_stats.start)
writes_start=$(awk '{print $8}' < vda_stats.start)
writeSect_start=$(awk '{print $10}' < vda_stats.start)
writeMs_start=$(awk '{print $11}' < vda_stats.start)

reads_end=$(awk '{print $4}' < vda_stats.end)
readSect_end=$(awk '{print $6}' < vda_stats.end)
readMs_end=$(awk '{print $7}' < vda_stats.end)
writes_end=$(awk '{print $8}' < vda_stats.end)
writeSect_end=$(awk '{print $10}' < vda_stats.end)
writeMs_end=$(awk '{print $11}' < vda_stats.end)

echo "rIop: $((reads_end-reads_start)), readGB: $(((readSect_end-readSect_start)*512/1024/1024/1024)), readMs: $((readMs_end-readMs_start)), wIop: $((writes_end-writes_start)), writeGB: $(((writeSect_end-writeSect_start)*512/1024/1024/1024)), writeMs: $((writeMs_end-writeMs_start)),"

