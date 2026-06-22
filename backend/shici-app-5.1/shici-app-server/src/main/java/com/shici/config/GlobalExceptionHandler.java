package com.shici.config;

import com.shici.common.R;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

  @ExceptionHandler(MethodArgumentNotValidException.class)
  public R<?> handleValid(MethodArgumentNotValidException ex) {
    String msg = ex.getBindingResult().getAllErrors().isEmpty()
        ? "参数错误"
        : ex.getBindingResult().getAllErrors().get(0).getDefaultMessage();
    return R.fail(msg);
  }

  @ExceptionHandler(Exception.class)
  public R<?> handle(Exception ex) {
    return R.fail(ex.getMessage());
  }
}
