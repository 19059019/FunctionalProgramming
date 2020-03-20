import Data.List

foldMaximum :: (Ord a) => [a] -> a
foldMaximum xs = foldl1 (\acc x -> if x > acc then x else acc) xs

foldMaximum' xs = foldl1 (\acc x -> if (snd x) > (snd acc) then x else acc) (zip [0..] xs)

maxIndex xs = head $ filter ((== maximum xs) . (xs !!)) [0..]

obs_name_1 :: [String]
obs_name_1 = [" Healthy ", " Fever "]
obs_1 :: [Int]
obs_1 = [0, 1, 2]
states_1 :: [Int]
states_1 = [0, 1]
start_p_1 :: [Double]
start_p_1 = [0.6, 0.4]
trans_p_1 :: [[Double]]
trans_p_1 = [[ 0.7, 0.3],
        [0.4, 0.6]]
emit_p_1 :: [[Double]]
emit_p_1 = [[0.5, 0.4, 0.1],
         [0.1, 0.3, 0.6]]


obs_name_2 :: [String]
obs_name_2 = [" Fair ", " Loaded "]
obs_2 :: [Int]
obs_2 = [1,0,1,0,0,0,1,0,1,1,0]
states_2 :: [Int]
states_2 = [0, 1]
start_p_2 :: [Double]
start_p_2 = [0.5, 0.5]
trans_p_2 :: [[Double]]
trans_p_2 = [[ 0.6, 0.4],
        [0.4, 0.6]]
emit_p_2 :: [[Double]]
emit_p_2 = [[0.5, 0.5],
         [0.8, 0.2]]


viterbi obs_name obs states start_p trans_p emit_p = do
    let t1 xs = foldr (\x acc -> (start_p !! x) * emit_p !! x !! 0 : acc ) [] xs
    let t2 xs = foldr (\x acc -> 0 : acc) [] xs
    let t1_1_internal transs state bases statess emit = [emit*(bases !! st)*(transs !! st !! state)| st <-statess]
    let t1_1 emits transs bases ob statess= [foldMaximum(t1_1_internal transs s (head bases) statess (emits !! s !! ob)) | s<-statess]
    let second_loop_t1 obss statess = foldl (\acc x -> t1_1 emit_p trans_p acc x statess : acc) [(t1 states)] obss
    let t1_final = foldl (\acc x -> x : acc) [] (second_loop_t1 (tail obs) states)
    let t2_1_internal transs state bases statess = [(bases !! st)*(transs !! st !! state)| st <-statess]
    let t2_1 transs bases ob statess= [fst (foldMaximum' (t2_1_internal transs s (bases !! (fst ob)) statess)) | s<-statess]    
    let second_loop_t2 t_1 obss statess = foldl (\acc x -> t2_1 trans_p t_1 x statess : acc) [(t2 states)] obss
    let t2_loop = foldl (\acc x -> x : acc) [] (second_loop_t2 t1_final (tail (zip [0..] obs)) states)
    let z = foldl (\acc x -> (x !! head acc) : acc) [1] (take ((length t2_loop) - 1) t2_loop)
    let x = foldl (\acc x -> acc ++ obs_name !! x) "Path:" z
    print(foldMaximum (last t1_final))
    print(x)

doctor = viterbi obs_name_1 obs_1 states_1 start_p_1 trans_p_1 emit_p_1
coin = viterbi obs_name_2 obs_2 states_2 start_p_2 trans_p_2 emit_p_2