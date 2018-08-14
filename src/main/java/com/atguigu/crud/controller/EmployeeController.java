package com.atguigu.crud.controller;


import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.validation.Valid;
import javax.xml.ws.RequestWrapper;
import java.util.HashMap;
import java.util.List;

/**
 * 处理员工CRUD请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 检查当前用户名是否可用
     * @param empName
     * @return
     */
    @RequestMapping("/checkEmpName")
    @ResponseBody
    public Msg checkEmpName(@RequestParam("empName")String empName){
        System.out.println(empName+"==========");
        // 先对用户名进行合法校验
        String empNameReg = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})|(^[\\u2E80-\\u9FFF_a-zA-Z0-9_-]{4,8}$)";
        if (!empName.matches(empNameReg)){
            System.out.println(empName.matches(empNameReg));
            return Msg.fail().add("va_msg","用户名必须是6到16位数字和字母的组合或者2到5位中文。");
        }
        // 数据库用户名重复校验
        boolean isCheck = employeeService.checkEmpName(empName);
        if (isCheck){
            System.out.println(111);
            return Msg.success().add("va_msg","用户名可用");
        }else {
            System.out.println(222);
            return Msg.fail().add("va_msg","用户名已存在");
        }
    }

    /**
     * 新增员工保存
     *  1.要支持JSR303校验
     *  2.导入hibernate-validator
     */
    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result) {
        if (result.hasErrors()){
            // 存放错误信息
            HashMap<String, Object> map = new HashMap<>();
            // 在模态框中显示错误信息
            List<FieldError> fieldErrors = result.getFieldErrors();
            for (FieldError fieldError : fieldErrors){
                System.out.println("错误的字段名："+fieldError.getField());
                System.out.println("错误信息："+fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        }else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    /**
     * 使用ajax返回json数据，实现平台的无关性
     * 需要导入jackson包
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
        // 得到所有员工
        // 引入分页插件pagehelper，在查询之前只需要调用 PageHelper.startPage(pageNum,pageSize);传入页面和每页数据数量
        PageHelper.startPage(pn, 5);
        List<Employee> emps = employeeService.getAll();
        // 用pageInfo对结果进行包装,只需要将pageInfo交给页面就行了
        // 封装了详细的分页信息，包括有我们查询出来的数据,传入需要连续显示的页数
        PageInfo pageInfo = new PageInfo(emps, 5);
        return Msg.success().add("pageInfo", pageInfo);
    }



    /*    *//**
     * 查询员工数据，分页查询,
     * 返回页面
     * @return
     *//*
    @RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn, Model model){

        // 得到所有员工
        // 引入分页插件pagehelper，在查询之前只需要调用 PageHelper.startPage(pageNum,pageSize);传入页面和每页数据数量
        PageHelper.startPage(pn,5);
        List<Employee> emps = employeeService.getAll();
        // 用pageInfo对结果进行包装,只需要将pageInfo交给页面就行了
        // 封装了详细的分页信息，包括有我们查询出来的数据,传入需要连续显示的页数
        PageInfo pageInfo = new PageInfo(emps,5);
        model.addAttribute("pageInfo",pageInfo);
        return "list";
    }*/
}
