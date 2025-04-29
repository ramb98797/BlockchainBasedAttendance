// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title AttendanceSystem
 * @dev Smart contract for recording and verifying attendance on blockchain
 */
contract AttendanceSystem {
    address public owner;
    
    // Struct to store attendance details
    struct AttendanceRecord {
        uint256 timestamp;
        bool present;
    }
    
    // Mapping from student address => date => attendance record
    mapping(address => mapping(uint256 => AttendanceRecord)) public attendanceRecords;
    
    // Events
    event AttendanceMarked(address indexed student, uint256 indexed date, uint256 timestamp);
    event BatchAttendanceMarked(address[] students, uint256 date);
    
    /**
     * @dev Constructor - sets the contract deployer as owner
     */
    constructor() {
        owner = msg.sender;
    }
    
    /**
     * @dev Mark attendance for a single student
     * @param student Address of the student
     * @param date Date in YYYYMMDD format (e.g., 20250429 for April 29, 2025)
     * @param present Boolean indicating whether the student is present
     */
    function markAttendance(address student, uint256 date, bool present) public {
        require(msg.sender == owner, "Only owner can mark attendance");
        
        attendanceRecords[student][date] = AttendanceRecord({
            timestamp: block.timestamp,
            present: present
        });
        
        emit AttendanceMarked(student, date, block.timestamp);
    }
    
    /**
     * @dev Mark attendance for multiple students at once
     * @param students Array of student addresses
     * @param date Date in YYYYMMDD format
     * @param present Boolean indicating whether the students are present
     */
    function markBatchAttendance(address[] memory students, uint256 date, bool present) public {
        require(msg.sender == owner, "Only owner can mark attendance");
        
        for (uint256 i = 0; i < students.length; i++) {
            attendanceRecords[students[i]][date] = AttendanceRecord({
                timestamp: block.timestamp,
                present: present
            });
        }
        
        emit BatchAttendanceMarked(students, date);
    }
    
    /**
     * @dev Verify attendance for a student on a specific date
     * @param student Address of the student
     * @param date Date in YYYYMMDD format
     * @return present Boolean indicating attendance status
     * @return timestamp Time when attendance was recorded
     */
    function verifyAttendance(address student, uint256 date) public view returns (bool present, uint256 timestamp) {
        AttendanceRecord memory record = attendanceRecords[student][date];
        return (record.present, record.timestamp);
    }
}
