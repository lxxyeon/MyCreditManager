//
//  MyCreditManager.swift
//  MyCreditManager
//
//  Created by leeyeon2 on 2023/04/19.
//

import Foundation

class MyCreditManager{
    
    // model
    var students = [Student]()
    var subjects = [String : String]()
    let scoreData = ["A+" : 4.5, "A" : 4, "B+" : 3.5, "B" : 3, "C+" : 2.5, "C" : 2, "D+" : 1.5, "D" : 1, "F" : 0]
    
    var isRun = true
    
    func showMenu() {
        
        while isRun{
            
            print("원하는 기능을 입력해주세요")
            print("1: 학생추가 , 2: 학생삭제 , 3: 성적추가(변경) , 4: 성적삭제 , 5: 평점보기 , X: 종료")
            
            let menu = readLine() ?? " "
            
            switch menu
            {
            case "1":
                addStudent()
            case "2":
                deleteStudent()
            case "3":
                addGrade()
            case "4":
                deleteGrade()
            case "5":
                showTotalGrade()
            case "X", "x" :
                exitProgram()
            default:
                errorInput()
            }
        }
    }
    
    // MARK: - 메뉴
    /// 1. 학생 추가
    func addStudent() {
        print("추가할 학생의 이름을 입력해주세요")
        let studentName = readLine() ?? " "
        
        if searchStudent(name: studentName){
            print("\(studentName)는 이미 존재하는 학생입니다. 추가하지 않습니다.")
        }else{
            students.append(Student(name: studentName, score: [:]))
            print("\(studentName) 학생을 추가했습니다.")
        }
    }
    
    /// 2. 학생 삭제
    func deleteStudent() {
        print("삭제할 학생의 이름을 입력해주세요.")
        let studentName = readLine() ?? " "
        
        if searchStudent(name: studentName){
            students.remove(at: students.firstIndex(where: {$0.name == studentName}) ?? 0)
            print("\(studentName) 학생을 삭제했습니다.")
        }else{
            print("\(studentName) 학생을 찾지 못했습니다.")
        }
    }
    
    /// 3. 성적추가(변경)
    func addGrade() {
        print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        print("입력예) Mickey Swift A+")
        print("만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
        let inputGrade = (readLine() ?? " ").components(separatedBy: " ")
        
        if inputGrade.count == 3 {
            if searchStudent(name: inputGrade[0]) && checkScore(score: inputGrade[2]){
                for (index, student) in students.enumerated(){
                    if student.name == inputGrade[0]{
                        let name = inputGrade[0]
                        let subject = inputGrade[1]
                        let score = scoreData[inputGrade[2].uppercased()]!
                        
                        students[index].score.updateValue(score, forKey: subject)
                        print("\(name) 학생의 \(subject) 과목이 \(inputGrade[2].uppercased())로 추가(변경)되었습니다.")
                        break
                    }
                }
            }else{
                print("\(inputGrade[0]) 학생을 찾지 못했습니다.")
            }
        }else{
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
        }
    }
    
    /// 4. 성적 삭제
    func deleteGrade() {
        print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        let inputGrade = (readLine() ?? " ").components(separatedBy: " ")
        
        if inputGrade.count == 2 {
            let name = inputGrade[0]
            let subject = inputGrade[1]

            if searchStudent(name: name){
                for (index, _) in students.enumerated(){
                    students[index].score.removeValue(forKey: subject)
                    print("\(name) 학생의 \(subject) 과목의 성적이 삭제되었습니다.")
                    break
                }
                
            }else{
                print("\(name) 학생을 찾지 못했습니다.")
                
            }
            
        }else{
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
        }
    }
    
    /// 5. 평점보기
    ///   각 과목의 점수 총 합 / 과목 수
    //    최대 소수점 2번째 자리까지 출력
    func showTotalGrade() {
        print("평점을 알고싶은 학생의 이름을 입력해주세요.")
        let studentName = readLine() ?? " "
        
        if searchStudent(name: studentName){
            for (index, student) in students.enumerated(){
                if student.name == studentName{
                    if students[index].score.isEmpty{
                        print("\(studentName) 학생의 점수를 찾지 못했습니다.")
                        break
                    }else{
                        var sumScore = 0.0
                        for (key, value) in students[index].score{
                            switch value{
                                case 4.5:
                                    print("\(key): A+")
                                case 4:
                                    print("\(key): A")
                                case 3.5:
                                    print("\(key): B+")
                                case 3:
                                    print("\(key): B")
                                case 2.5:
                                    print("\(key): C+")
                                case 2:
                                    print("\(key): C")
                                case 1.5:
                                    print("\(key): D+")
                                case 1:
                                    print("\(key): D")
                                case 0:
                                    print("\(key): D")
                                default:
                                    break
                            }
                            sumScore += value
                        }
                        let totalGrade = String(format: "%.2f", sumScore/Double(student.score.count))
                        print("평점 : " + totalGrade)
                        break
                    }
                }
            }
        }else{
            print("\(studentName) 학생을 찾지 못했습니다.")
        }
    }
    
    // 6. 종료
    func exitProgram() {
        print("프로그램을 종료합니다...")
        exit(0)
    }
    
    //MARK: - 기능 메소드
    
    /// 학생 중복 체크
    /// - Parameter name: 학생 이름
    /// - Returns: 중복 체크 결과 (Bool)
    func searchStudent(name: String) -> Bool {
        for student in students{
            if student.name == name {
                return true
            }
        }
        return false
    }
    
    /// 점수 유효성 체크
    /// - Parameter score: 점수
    /// - Returns: 유효성 체크 결과 (Bool)
    func checkScore(score: String) -> Bool {
        for key in scoreData.keys{
            if(key == score.uppercased()){
                return true
            }
        }
        return false
    }
    // 잘못 입력 처리
    func errorInput() {
        print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
    }
}
